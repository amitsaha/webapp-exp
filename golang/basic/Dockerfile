FROM golang:1.12 as build

WORKDIR /go/src/app
COPY . .

RUN go install -v ./...

# Now copy it into our base image.
FROM gcr.io/distroless/base
COPY --from=build /go/bin/app /
CMD ["/app"]
