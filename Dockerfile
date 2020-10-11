FROM golang:1.13-alpine AS builder

RUN apk add --update gcc musl-dev git

ENV GOPATH /tmp/buildcache
COPY *.go go.* /tmp/acme-dns/
WORKDIR /tmp/acme-dns
RUN CGO_ENABLED=1 go build

FROM alpine:latest

WORKDIR /root/
COPY --from=builder /tmp/acme-dns/acme-dns .
RUN mkdir -p /etc/acme-dns
RUN mkdir -p /var/lib/acme-dns
RUN apk --no-cache add ca-certificates && update-ca-certificates

VOLUME ["/etc/acme-dns", "/var/lib/acme-dns"]
ENTRYPOINT ["./acme-dns"]
EXPOSE 53 80 443
EXPOSE 53/udp
