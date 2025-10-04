FROM cgr.dev/chainguard/go:latest@sha256:af15101dfd248bbedc9d88bd8735005fa21818887a8af10411842308954a46d6 AS build

RUN git clone https://github.com/derailed/k9s /go/src/k9s

WORKDIR /go/src/k9s

RUN go clean --testcache && go test

RUN CGO_ENABLED=0 GOOS=$(uname | tr '[A-Z]' '[a-z]') go build -a -o /go/bin/k9s main.go

FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:541.0.0-stable@sha256:f0fc3d13be3b184c4794b6d72a7ee857473732aaf74cd5ecc09ae9fcddf51a1e

RUN apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

COPY --from=build /go/bin/k9s /usr/local/bin

ENTRYPOINT ["/usr/local/bin/k9s"]
