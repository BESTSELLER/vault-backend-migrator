FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/vault-backend-migrator
COPY . .
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /tmp/vault-backend-migrator

FROM alpine
COPY --from=builder /tmp/vault-backend-migrator /vault-backend-migrator
COPY docker-entrypoint.sh /
RUN chmod +x "/docker-entrypoint.sh"
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/vault-backend-migrator"]