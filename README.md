# docker-image-tools

A Docker image and GitHub workflow that builds the tools we need for our main Docker image.
The image uses native cross-compilation to build the tools for both `x86_64` and `aarch64` instead of using emulation. This makes the build significantly faster.

### Push to Docker Hub
The workflow will build the Docker image if necessary, and push it to Docker hub.

### Compile binaries
The tools will be built when `scripts/build.sh` or `scripts/export.sh` change, or when a new image has been built. They are provided as artifacts.

### Release
If a commit is tagged, the workflow will run, and a new release will be created. The tools will be uploaded as assets in the release. The release will have the same name as the tag.
