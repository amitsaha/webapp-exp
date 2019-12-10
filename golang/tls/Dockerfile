FROM golang:1.12
WORKDIR /go/src/app
COPY . .
RUN go build && mv app /app
RUN groupadd -r application && useradd --no-log-init -r -g application application
USER application
CMD ["/app"]
