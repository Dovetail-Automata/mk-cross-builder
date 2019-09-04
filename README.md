# Machinekit Cross-Builder

This builds Debian Docker images with tools and dependencies for
building/cross-building Machinekit packages.  For cross-building
`armhf`, `arm64` and `i386` architectures, the image contains a
`multistrap` system root tree, and for native `amd64` builds the image
contains needed dependencies and tools in the root filesystem.

## Using the images

- Determine `$TAG` for the desired architecture and distro
  combination.  The format is `$ARCH_$DISTRO`, where `$ARCH` may be
  one of `amd64`, `i386`, `armhf`, `arm64`; `$DISTRO` may be one of
  `8` for Jessie, `9` for Stretch, `10` for Buster;
  e.g. `TAG=armhf_10`.

- To build Machinekit in a Docker container with cross-build tools,
  `cd` into a Machinekit source tree:

        # Build source and binary packages for $TAG
		scripts/build_docker -t $TAG -c deb

		# Build amd64 binary-only packages (no source) for Jessie
		scripts/build_docker -t amd64_8 -c deb -n

		# Build amd64_10 (default) RIP build with regression tests
		scripts/build_docker -c test

		# Run command in container
		scripts/build_docker -t $TAG bash -c 'echo $HOST_MULTIARCH'

	- Note that source packages are only built by default on
      `amd64_*`, the native architecture.
    - The source package build will fail if the source tree isn't
      checked into git and completely cleaned with e.g. `git clean
      -xdf`

- Querying packages in the sysroot:

Package management commands require special incantations for
manipulating the multistrap filesystem.  Run these inside the
container (see above `build_docker -c` command).

        # Installed packages
        dpkg-query --admindir=$DPKG_ROOT/var/lib/dpkg -p libczmq-dev

        # Apt cache
        apt-cache -o Dir::State=$DPKG_ROOT/var/lib/apt/ show libczmq-dev


## Updating the Machinekit dependencies

Machinekit dependencies are auto-generated from the Machinekit source
tree `debian/` directory.  When those files are updated, the
`configure` and `control.in` files should be copied here.

        cp $(MK_REPO)/debian/configure debian/
        cp $(MK_REPO)/debian/control.in debian/

## Building locally

Build images locally with the supplied script, supplying the
image name, e.g.:

    ./build.sh my_docker_id/mk-cross-builder:arm64_10

# Automated image builds and CI

These images can be automatically build on Docker Hub, and be used in
Travis CI to test Machinekit.

## Set up hub.docker.com automated `mk-cross-builder` image builds

- Fork this repo into a GitHub account
- From your Docker Hub account:
  - [Link][dh-gh] your GitHub account
  - [Create][dh-qs] a repository `mk-cross-builder`
  - [Configure][dh-ab] the automated build from the repository page:
    - Click the "Builds" tab
    - Click "Configure automated builds"
    - Select the source repository:  your GitHub ID and the
      `mk-cross-builder` repository
    - Click "+" to add build rules for each `<arch>_<distro-ver>` tag:
      - "Source Type" "Branch"
      - "Source" "master"
      - "Docker tag" the `<arch>_<distro-ver>` tag
      - "Dockerfile location" "/Dockerfile"
      - "Build context" (empty/default)
      - "Autobuild"  Click on
      - "Build Caching"  Click on (if you will update the GitHub repo
        often) or off
    - Click "Save and Build" to build the first images

Automated builds should now be triggered whenever a new commit is
pushed to the GitHub repository `master` branch.

[dh-gh]: https://docs.docker.com/docker-hub/builds/link-source/
[dh-qs]: https://docs.docker.com/docker-hub/
[dh-ab]: https://docs.docker.com/docker-hub/builds/

## Set up Travis CI automated `machinekit-hal` builds

Set up Travis CI to automatically build and test your GitHub
`machinekit-hal` repository.

- Fork the [`machinekit-hal` repository][mk-hal] into your GitHub
  account
- Set up Travis CI
  - [Log in][tci-gh] to Travis CI with your GitHub account
  - Go to "Settings" for your user account (upper right drop-down menu)
  - On the "Repositories" tab, find the `machinekit-hal` repository
    (click "Sync account" if it doesn't appear)
    - Switch it on
    - Click "Settings" to configure the repository build
  - Configure the repository settings
    - To use your custom Docker Hub images, configure the `$IMAGE`
      environment variable
      - "Name" `IMAGE`
      - "Value" `<your_docker_hub_id>/mk-cross-builder`
      - "Display value in build log" Click on
      - Click "Add"
    - If you don't configure the `$IMAGE`, the default
      `dovetailautomata/mk-cross-builder` images will be used
    - Optionally adjust other settings
  - In the "More options" hamburger menu, click "Trigger build"

Travis CI should now begin building the repository.  Every new commit
pushed to GitHub will also trigger a new build.

[mk-hal]: https://github.com/machinekit/machinekit-hal
[tci-gh]: https://docs.travis-ci.com/user/tutorial/#to-get-started-with-travis-ci
