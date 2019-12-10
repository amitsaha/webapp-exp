FROM golang:1.12
WORKDIR /go/src/app
COPY . .
RUN go build && mv app /app
USER nobody
CMD ["/app"]
