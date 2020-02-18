FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/vault-backend-migrator
COPY . .
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /tmp/vault-backend-migrator

FROM google/cloud-sdk:alpine
COPY --from=builder /tmp/vault-backend-migrator /vault-backend-migrator
RUN apk add --no-cache jq curl zip vault 

CMD ["/bin/sh"]