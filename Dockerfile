FROM golang:1.22

WORKDIR /app

RUN go install -tags 'mysql' github.com/golang-migrate/migrate/v4/cmd/migrate@latest