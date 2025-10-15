FROM docker.io/golang:1.25.3-trixie@sha256:88ba6af1b83398ee93c4753b7f746bd979ce369d759a058c80667c46db6341ff AS build

RUN git clone https://github.com/kubernetes/kompose.git /go/src/kompose

WORKDIR /go/src/kompose

RUN go clean --testcache && go test

RUN CGO_ENABLED=0 GOOS=$(uname | tr '[A-Z]' '[a-z]') go build -a -o /go/bin/kompose main.go

#FROM gcr.io/distroless/static-debian12

#COPY --from=build /go/bin/kompose /usr/local/bin

#ENTRYPOINT ["/usr/local/bin/kompose"]
ENTRYPOINT ["/go/bin/kompose"]
