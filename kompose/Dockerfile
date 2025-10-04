FROM docker.io/golang:1.25.1-trixie@sha256:61226c61f37cb86253c4ac486ef22c47f14bfddb8f60bb4805bfc165001be758 AS build

RUN git clone https://github.com/kubernetes/kompose.git /go/src/kompose

WORKDIR /go/src/kompose

RUN go clean --testcache && go test

RUN CGO_ENABLED=0 GOOS=$(uname | tr '[A-Z]' '[a-z]') go build -a -o /go/bin/kompose main.go

#FROM gcr.io/distroless/static-debian12

#COPY --from=build /go/bin/kompose /usr/local/bin

#ENTRYPOINT ["/usr/local/bin/kompose"]
ENTRYPOINT ["/go/bin/kompose"]
