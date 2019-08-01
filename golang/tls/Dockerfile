FROM golang:1.12
WORKDIR /go/src/app
COPY . .
RUN go build && mv app /app
CMD ["/app"]
