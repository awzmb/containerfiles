FROM docker.io/node:24.9.0-alpine3.21@sha256:843a738e7405b4fb42b2fc37d6c99cd2063af9f48852968a09851129a96b0ebf AS build

WORKDIR /app

RUN apk add --no-cache curl bash
RUN npm cache clean --force
RUN npm i playwright playwright-extra puppeteer-extra-plugin-stealth
RUN npx -y playwright install chromium
RUN curl -L -s --url "https://raw.githubusercontent.com/KevCui/copilot-cli/refs/heads/main/copilot.js" --output /app/copilot.js

#FROM gcr.io/distroless/nodejs22-debian12

#COPY --from=build /app /app
#CMD ["/app/node_modules/.bin/ai"]
