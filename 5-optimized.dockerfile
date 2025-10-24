FROM golang:alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY main.go .

RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o app .

FROM alpine

RUN adduser -D appuser
USER appuser

WORKDIR /home/appuser/app

COPY --from=builder /app/app .

EXPOSE 8080

CMD ["./app"]