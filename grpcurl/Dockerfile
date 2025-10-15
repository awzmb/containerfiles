FROM docker.io/golang:1.25.3-trixie@sha256:88ba6af1b83398ee93c4753b7f746bd979ce369d759a058c80667c46db6341ff AS build

RUN git clone https://github.com/fullstorydev/grpcurl.git /go/src/grpcurl

WORKDIR /go/src/grpcurl

RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=$(uname | tr '[A-Z]' '[a-z]') go build -o /go/bin/grpcurl

FROM gcr.io/distroless/static-debian12:latest@sha256:87bce11be0af225e4ca761c40babb06d6d559f5767fbf7dc3c47f0f1a466b92c

COPY --from=build /go/bin/grpcurl /usr/local/bin
COPY --from=kubectl /usr/bin/kubectl /usr/bin

ENTRYPOINT ["grpcurl"]
