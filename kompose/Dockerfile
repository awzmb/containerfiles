FROM docker.io/golang:1.25.3-trixie@sha256:83defe6e67782eefe60d5cd3241d2f2ffee05d27ffa9c953caa1d21cc8f4304b AS build

RUN git clone https://github.com/kubernetes/kompose.git /go/src/kompose

WORKDIR /go/src/kompose

RUN go clean --testcache && go test

RUN CGO_ENABLED=0 GOOS=$(uname | tr '[A-Z]' '[a-z]') go build -a -o /go/bin/kompose main.go

#FROM gcr.io/distroless/static-debian12

#COPY --from=build /go/bin/kompose /usr/local/bin

#ENTRYPOINT ["/usr/local/bin/kompose"]
ENTRYPOINT ["/go/bin/kompose"]
