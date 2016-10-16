#!/bin/bash -e

# For each tag (non-`master`) branch:
#    - check out branch
#    - hard reset to base (`master`) branch
#    - add and commit tag changes

###################################################################
# Tag branch settings

BASE_BRANCH="master"
TAGS="amd64 armhf i386 raspbian"
ATTRS="DEBIAN_ARCH SYS_ROOT HOST_MULTIARCH DISTRO EXTRA_FLAGS"

declare -A SETTINGS_amd64=(
    [DEBIAN_ARCH]="amd64"
    [SYS_ROOT]=
    [HOST_MULTIARCH]="x86_64-linux-gnu"
    [DISTRO]="jessie"
    [EXTRA_FLAGS]=
)
declare -A SETTINGS_armhf=(
    [DEBIAN_ARCH]="armhf"
    [SYS_ROOT]="/sysroot/armhf"
    [HOST_MULTIARCH]="arm-linux-gnueabihf"
    [DISTRO]="jessie"
    [EXTRA_FLAGS]=
)
declare -A SETTINGS_i386=(
    [DEBIAN_ARCH]="i386"
    [SYS_ROOT]="/sysroot/i386"
    [HOST_MULTIARCH]="i386-linux-gnu"
    [DISTRO]="jessie"
    [EXTRA_FLAGS]="-m32"
)
declare -A SETTINGS_raspbian=(
    [DEBIAN_ARCH]="armhf"
    [SYS_ROOT]="/sysroot/rpi"
    [HOST_MULTIARCH]="arm-linux-gnueabihf"
    [DISTRO]="raspbian"
    [EXTRA_FLAGS]=
)

###################################################################
# Safety checks

# Are there any uncommitted changes?
if git status | grep -q 'Changes not staged for commit'; then
    echo "Uncommitted changes:  aborting" >&2
    exit 1
fi
if git status | grep -q 'Untracked files'; then
    echo "Untracked files:  aborting" >&2
    exit 1
fi
echo "No uncommitted changes or untracked files:  OK"

# Is the base branch checked out?
if test $(git rev-parse --abbrev-ref HEAD) != $BASE_BRANCH; then
    echo "Current branch not $BASE_BRANCH;" \
	"are you modifying the right branch?" >&2
    exit 1
fi
echo "Current branch is $BASE_BRANCH:  OK" >&2

# Are there any unexpected changes on other branches?
for TAG in $TAGS; do
    NON_BASE_COMMITS=$(
	git log --pretty=oneline $BASE_BRANCH..$TAG | wc -l)
    if test "$NON_BASE_COMMITS" -gt 1; then
	echo "$TAG branch:  there are $NON_BASE_COMMITS not in" \
	    "the $BASE_BRANCH branch; should be exactly 1" >&2
	echo -n "Hit return to ignore or C-c to abort"; read FOO
    fi
    echo "$NON_BASE_COMMITS commit to $TAG not in $BASE_BRANCH:  OK"
done

###################################################################
# Update tag branches

# Checks all passed; now reset each tag branch to master and add an
# extra commit with tag settings
(   #set -x  # Show user what we're doing in this part
    for TAG in $TAGS; do
	echo "$TAG:"

	# Copy associative array SETTINGS_<tag> to SETTINGS
	eval $(declare -p SETTINGS_$TAG | sed 's/SETTINGS_[^=]*=/SETTINGS=/')

	# Check out tag branch and hard-reset to base branch
	git checkout $TAG
	git reset --hard $BASE_BRANCH

	# Customize Dockerfile for the tag
	for KEY in $ATTRS; do
	    eval VAL="\${SETTINGS_$TAG[$KEY]}"
	    echo "    $KEY=$VAL"
	    # Inefficient to do it one value at a time, but I'm lazy
	    sed -i Dockerfile -e "s,@$KEY@,$VAL,"
	done
	git commit -m "Set tag to $TAG" Dockerfile
    done
)
git checkout $BASE_BRANCH

# Show user what we've done
git show-branch
git branch -vv
echo 'Now run `git push -f --all`, if desired' >&2
