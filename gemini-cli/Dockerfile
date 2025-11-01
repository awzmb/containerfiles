FROM docker.io/node:25.1.0-alpine3.21@sha256:afcd03e0c9ae83fc30d48c8f05de72938e116d83b58b8220debfd0f56aff67ae AS build

WORKDIR /app

# Install gemini-cli using npm. This installs it and all its
# dependencies into /app/node_modules
RUN npm install @google/gemini-cli@v0.11.3


FROM gcr.io/distroless/nodejs24-debian12:latest@sha256:ac05a8febf24b547f09068149fcd6a071f69629cb2148b6f707a157e7f4c6306

# Set the working directory
WORKDIR /app

# Copy the installed node_modules (which includes gemini-cli
# and all its dependencies) from the builder stage.
COPY --from=build /app/node_modules ./node_modules

# The distroless nodejs image has its ENTRYPOINT set to ["/usr/bin/node"].
# We just need to provide the path to the main JavaScript file as the CMD.
# This file is the actual script that the 'gemini' command executes.
CMD ["/app/node_modules/@google/gemini-cli/dist/index.js"]
