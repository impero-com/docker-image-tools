# docker-image-tools

A Docker image and GitHub workflow that builds the tools we need for our main Docker image.
The image uses native cross-compilation to build the tools for both `x86_64` and `aarch64` instead of using emulation. This makes the build significantly faster.

### CI
When changes are made and pushed, the Docker image will be built, and the binaries will be built for both `x86_64` and `aarch64` using this image. The binaries will be available as artifacts for 5 days, but the image will be deleted immediately after the workflow completes.

### Release
If a commit is tagged, the workflow will run, and a new release will be created. The binaries will be uploaded as assets in the release. The release will have the same name as the tag.

### Development

* On `x86_64`: run `./scripts/build.sh`
* On `aarch64`: TODO
  * rename `Dockerfile` to `Dockerfile.x86_64`
  * create `Dockerfile.aarch64`
  * make the build script choose the image based on `uname -m`
  * fix CI on `x86_64`
