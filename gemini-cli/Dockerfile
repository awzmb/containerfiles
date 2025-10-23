FROM docker.io/node:25.0.0-alpine3.21@sha256:54a2c8c7113949ec9b177738aaa7188529b73e2cbcf1d572e62bbe4c2e7e4df0 AS build

WORKDIR /app

# Install gemini-cli using npm. This installs it and all its
# dependencies into /app/node_modules
RUN npm install @google/gemini-cli@v0.10.0


FROM gcr.io/distroless/nodejs24-debian12:latest@sha256:acc00c9fd71a24aea69e53c01cee55f54383182af2557b9ec77432bbb36ec911

# Set the working directory
WORKDIR /app

# Copy the installed node_modules (which includes gemini-cli
# and all its dependencies) from the builder stage.
COPY --from=build /app/node_modules ./node_modules

# The distroless nodejs image has its ENTRYPOINT set to ["/usr/bin/node"].
# We just need to provide the path to the main JavaScript file as the CMD.
# This file is the actual script that the 'gemini' command executes.
CMD ["/app/node_modules/@google/gemini-cli/dist/index.js"]
