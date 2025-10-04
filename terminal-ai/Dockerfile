FROM cgr.dev/chainguard/node:24.8.0 AS build

WORKDIR /app

RUN npm install @dwmkerr/terminal-ai

FROM gcr.io/distroless/nodejs22-debian12:latest@sha256:4457cf5f47fa4bc2d3a3733feb08180bdbd5fd0ee176da532984ab2444b76fcc

COPY --from=build /app /app

ENTRYPOINT ["/app/node_modules/.bin/ai"]
