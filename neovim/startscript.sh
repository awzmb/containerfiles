#!/bin/bash

IMAGE_NAME="localhost/neovim:latest"
VOLUME_NAME="neovim_home"
USERNAME=$(whoami)
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Check if the podman volume exists.
if ! podman volume exists "${VOLUME_NAME}" &> /dev/null; then
  echo "Creating persistent podman volume: ${VOLUME_NAME}"
  podman volume create "${VOLUME_NAME}" > /dev/null

  # One-time initialization of the volume's permissions.
  # We run a temporary container as root to chown the volume's contents
  # to the current user's UID/GID.
  echo "Initializing volume permissions for user ${USER_ID}:${GROUP_ID}..."
  podman run --rm \
    --user root \
    --volume "${VOLUME_NAME}:/home/${USERNAME}:Z" \
    "${IMAGE_NAME}" \
    chown -R "${USER_ID}:${GROUP_ID}" /home/${USERNAME}
fi

if [ ! -e /tmp/wayland-1 ]; then
  echo "Error: /tmp/wayland-1 not found. Please run the following command in a separate terminal:"
  echo "socat UNIX-LISTEN:/tmp/wayland-1,fork,mode=777 UNIX-CONNECT:\${XDG_RUNTIME_DIR}/\${WAYLAND_DISPLAY}"
  exit 1
fi

# The main run command
podman run --rm -it \
  --group-add "${GROUP_ID}" \
  --group-add video \
  --group-add render \
  --env WAYLAND_DISPLAY=wayland-1 \
  --env XDG_RUNTIME_DIR=/tmp \
  --env XDG_SESSION_TYPE=wayland \
  --volume /tmp/wayland-1:/tmp/wayland-1:Z \
  --user "${USER_ID}:${GROUP_ID}" \
  --volume "${VOLUME_NAME}:/home/${USERNAME}:Z" \
  --volume "${PWD}:/workspace:Z" \
  --workdir /workspace \
 "${IMAGE_NAME}" "$@"
