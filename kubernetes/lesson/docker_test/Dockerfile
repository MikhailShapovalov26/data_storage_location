FROM golang:1.19 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app main.go

FROM alpine:latest
WORKDIR /root/
COPY --from=builder ./app .
EXPOSE 8080
CMD ["./app"]