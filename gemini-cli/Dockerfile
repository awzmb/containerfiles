FROM docker.io/node:24.9.0-alpine3.21@sha256:843a738e7405b4fb42b2fc37d6c99cd2063af9f48852968a09851129a96b0ebf AS build

WORKDIR /app

# Install gemini-cli using npm. This installs it and all its
# dependencies into /app/node_modules
RUN npm install @google/gemini-cli@v0.6.1


FROM gcr.io/distroless/nodejs24-debian12:latest@sha256:10399fcb07704d1bc2fbf9d464db179bb525aa360ed86628ef652ef43609ff96

# Set the working directory
WORKDIR /app

# Copy the installed node_modules (which includes gemini-cli
# and all its dependencies) from the builder stage.
COPY --from=build /app/node_modules ./node_modules

# The distroless nodejs image has its ENTRYPOINT set to ["/usr/bin/node"].
# We just need to provide the path to the main JavaScript file as the CMD.
# This file is the actual script that the 'gemini' command executes.
CMD ["/app/node_modules/@google/gemini-cli/dist/index.js"]
