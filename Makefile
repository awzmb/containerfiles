# Get all subdirectories with a Containerfile
DIRS := $(wildcard */Dockerfile)

# Extract the names of the directories
IMAGES := $(patsubst %/Dockerfile,%,$(DIRS))

# Default target to build all images
all: $(IMAGES)

# Rule to build each image
$(IMAGES):
	podman buildx build --tag $@ -f $@/Dockerfile $@

.PHONY: all $(IMAGES)

update:
	podman run --rm -it --volume "${PWD}":/workspace --volume "$HOME/.gitconfig:/home/ubuntu/.gitconfig:ro" --workdir /workspace ghcr.io/updatecli/updatecli:latest apply
	# podman run --rm -it --volume "${PWD}":/workspace --volume "$HOME/.gitconfig:/home/ubuntu/.gitconfig:ro" --workdir /workspace docker.io/renovate/renovate:latest renovate --platform=local
