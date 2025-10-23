FROM docker.io/debian:bookworm-20250929@sha256:93492d1405a072c9d3b89110490e330e0b7eb37754cafc9520908b7fe6873f5f AS build

RUN apt-get update && apt-get install -y \
  curl \
  unzip \
  tar \
  grep \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

ADD ./install-k9s.sh /tmp/install-k9s.sh

RUN chmod +x /tmp/install-k9s.sh && /tmp/install-k9s.sh

# FROM docker.io/golang:latest AS build
#
# RUN git clone https://github.com/derailed/k9s /go/src/k9s
#
# WORKDIR /go/src/k9s
#
# RUN go clean --testcache && go test
#
# RUN CGO_ENABLED=0 GOOS=$(uname | tr '[A-Z]' '[a-z]') go build -a -o /go/bin/k9s main.go

FROM cgr.dev/chainguard/kubectl:latest@sha256:bb1770e01601f4e1b053411030c51e419643625d4535b87054042517dcc2b878 as kubectl

FROM gcr.io/distroless/static-debian12:latest@sha256:87bce11be0af225e4ca761c40babb06d6d559f5767fbf7dc3c47f0f1a466b92c

COPY --from=build /usr/local/bin/k9s /usr/local/bin/k9s
# COPY --from=build /go/bin/k9s /usr/local/bin
COPY --from=kubectl /usr/bin/kubectl /usr/bin

ENTRYPOINT ["k9s"]
