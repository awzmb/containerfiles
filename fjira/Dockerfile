FROM docker.io/golang:1.25.1-trixie@sha256:61226c61f37cb86253c4ac486ef22c47f14bfddb8f60bb4805bfc165001be758 AS build

RUN git clone https://github.com/mk-5/fjira.git /go/src/fjira

WORKDIR /go/src/fjira

RUN CGO_ENABLED=0 GOOS=$(uname | tr '[A-Z]' '[a-z]') go build -a -o /go/bin/fjira cmd/fjira-cli/main.go

FROM gcr.io/distroless/static-debian12:latest@sha256:87bce11be0af225e4ca761c40babb06d6d559f5767fbf7dc3c47f0f1a466b92c

COPY --from=build /go/bin/fjira /usr/local/bin/fjira

ENTRYPOINT ["/usr/local/bin/fjira"]
