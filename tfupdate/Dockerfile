FROM docker.io/golang:1.25.1@sha256:d7098379b7da665ab25b99795465ec320b1ca9d4addb9f77409c4827dc904211 AS build

RUN git clone https://github.com/minamijoyo/tfschema.git /go/src/tfschema

WORKDIR /go/src/tfschema

RUN go clean --testcache && go test

RUN CGO_ENABLED=0 GOOS=$(uname | tr '[A-Z]' '[a-z]') go build -a -o /go/bin/tfschema main.go

FROM gcr.io/distroless/static-debian12:latest@sha256:87bce11be0af225e4ca761c40babb06d6d559f5767fbf7dc3c47f0f1a466b92c

COPY --from=build /go/bin/tfschema /usr/local/bin/tfschema

ENTRYPOINT ["/usr/local/bin/tfschema"]
