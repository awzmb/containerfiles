# Get all subdirectories with a Containerfile
DIRS := $(wildcard */Containerfile)

# Extract the names of the directories
IMAGES := $(patsubst %/Containerfile,%,$(DIRS))

# Default target to build all images
all: $(IMAGES)

# Rule to build each image
$(IMAGES):
	podman buildx build --tag $@ -f $@/Containerfile $@

.PHONY: all $(IMAGES)