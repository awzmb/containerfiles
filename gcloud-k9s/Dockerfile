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

FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:544.0.0-stable@sha256:d1ccfc3d02db16a9d7c33cccc3c6265f6f67ab6d9b4862f4e0df0b7d09a1f03d

COPY --from=build /usr/local/bin/k9s /usr/local/bin/k9s

ENTRYPOINT ["/usr/local/bin/k9s"]
