FROM golang:1.13.3 as builder

WORKDIR /go/src/webapp
COPY src/ src/
RUN go build src/main.go

FROM golang:1.13.3 as RUN
WORKDIR /go/src/webapp
COPY --from=builder /go/src/webapp/main ./
COPY --from=builder /go/src/webapp/src/homepage.html ./

EXPOSE 5000
CMD ["./main"]