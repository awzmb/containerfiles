FROM docker.io/node:24.10.0-alpine3.21@sha256:24085db06725487642885c4d4f7f156aeac0dc4b881b10dabb38cb8d5e142577 AS build

WORKDIR /app

# Install gemini-cli using npm. This installs it and all its
# dependencies into /app/node_modules
RUN npm install @google/gemini-cli@v0.9.0


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
