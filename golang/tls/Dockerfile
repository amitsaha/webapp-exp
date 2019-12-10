FROM golang:1.12
WORKDIR /go/src/app
COPY . .
RUN go build && mv app /app
RUN groupadd -g 1000 -r application && useradd --no-log-init -u 1000 -g application application
USER application
CMD ["/app"]
