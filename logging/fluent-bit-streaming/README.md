# fluent bit tagging at runtime

This demo aims to demonstrate tagging fluent bit logs at runtime based on
the fields in a log line. This uses [fluent bit streaming](https://docs.fluentbit.io/manual/configuration/stream_processor).

The `sample.log` has 5 log lines, with one containing the `request_body` field. We only want to emit
this line in the `stdout` output and ignore the others. The the way this is done is by using two
`[STREAM_TASK]`s to tag the logs differently:

```
[STREAM_TASK]
    Name example
    Exec CREATE STREAM payloads WITH(tag='type1') AS SELECT * FROM STREAM:tail.0 WHERE @record.contains(request_body);

[STREAM_TASK]
    
    Name example1
    Exec CREATE STREAM nopayloads WITH(tag='type2') AS SELECT * FROM STREAM:tail.0 WHERE NOT @record.contains(request_body);
```


Then, in the output configuration:

```
[OUTPUT]
    Name  null
    Match  type2

[OUTPUT]
    Name  stdout
    Match  type1
```

To run the demo `./start_fluent-bit.sh`