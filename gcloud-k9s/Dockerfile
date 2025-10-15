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

FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:543.0.0-stable@sha256:cbd590ab2c25667f741550514856b17514887a3789d33068724b4f20abe2d2eb

COPY --from=build /usr/local/bin/k9s /usr/local/bin/k9s

ENTRYPOINT ["/usr/local/bin/k9s"]
