# arch/distro/version configuration

declare -A SETTINGS_amd64_8=(
    [DEBIAN_ARCH]="amd64"
    [SYS_ROOT]=
    [HOST_MULTIARCH]="x86_64-linux-gnu"
    [DISTRO_CODENAME]="jessie"
    [BASE_IMAGE]="debian:jessie"
    [DISTRO_VER]="8"
    [EXTRA_FLAGS]=
)
declare -A SETTINGS_armhf_8=(
    [DEBIAN_ARCH]="armhf"
    [SYS_ROOT]="/sysroot"
    [HOST_MULTIARCH]="arm-linux-gnueabihf"
    [DISTRO_CODENAME]="jessie"
    [BASE_IMAGE]="debian:jessie"
    [DISTRO_VER]="8"
    [EXTRA_FLAGS]=
)
declare -A SETTINGS_i386_8=(
    [DEBIAN_ARCH]="i386"
    [SYS_ROOT]="/sysroot"
    [HOST_MULTIARCH]="i386-linux-gnu"
    [DISTRO_CODENAME]="jessie"
    [BASE_IMAGE]="debian:jessie"
    [DISTRO_VER]="8"
    [EXTRA_FLAGS]="-m32"
)
declare -A SETTINGS_raspbian_8=(
    [DEBIAN_ARCH]="armhf"
    [SYS_ROOT]="/sysroot"
    [HOST_MULTIARCH]="arm-linux-gnueabihf"
    [DISTRO_CODENAME]="raspbian"
    [BASE_IMAGE]="debian:jessie"
    [DISTRO_VER]="8"
    [EXTRA_FLAGS]=
)

declare -A SETTINGS_amd64_9=(
    [DEBIAN_ARCH]="amd64"
    [SYS_ROOT]=
    [HOST_MULTIARCH]="x86_64-linux-gnu"
    [DISTRO_CODENAME]="stretch"
    [BASE_IMAGE]="debian:stretch"
    [DISTRO_VER]="9"
    [EXTRA_FLAGS]=
)
declare -A SETTINGS_armhf_9=(
    [DEBIAN_ARCH]="armhf"
    [SYS_ROOT]="/sysroot"
    [HOST_MULTIARCH]="arm-linux-gnueabihf"
    [DISTRO_CODENAME]="stretch"
    [BASE_IMAGE]="debian:stretch"
    [DISTRO_VER]="9"
    [EXTRA_FLAGS]=
)
declare -A SETTINGS_i386_9=(
    [DEBIAN_ARCH]="i386"
    [SYS_ROOT]="/sysroot"
    [HOST_MULTIARCH]="i386-linux-gnu"
    [DISTRO_CODENAME]="stretch"
    [BASE_IMAGE]="debian:stretch"
    [DISTRO_VER]="9"
    [EXTRA_FLAGS]="-m32"
)
declare -A SETTINGS_raspbian_9=(
    [DEBIAN_ARCH]="armhf"
    [SYS_ROOT]="/sysroot"
    [HOST_MULTIARCH]="arm-linux-gnueabihf"
    [DISTRO_CODENAME]="raspbian"
    [BASE_IMAGE]="debian:stretch"
    [DISTRO_VER]="9"
    [EXTRA_FLAGS]=
)
