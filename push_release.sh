#!/bin/bash

VERSION=""

git fetch --all

echo -e ''

#get parameters
while getopts v: flag
do
  case "${flag}" in
    v) VERSION=${OPTARG};;
  esac
done

#get highest tag number, and add 1.0.0 if doesn't exist
# CURRENT_VERSION=`git describe --abbrev=0 --tags 2>/dev/null`
CURRENT_VERSION=`git tag --sort=committerdate | grep -E '^v[0-9]+.[0-9]+.[0-9]+' | tail -1 | cut -b 2-`

if [[ $CURRENT_VERSION == '' ]]
then
  CURRENT_VERSION='1.0.0'
fi
echo "Current Version: v$CURRENT_VERSION"


#replace . with space so can split into an array
CURRENT_VERSION_PARTS=(${CURRENT_VERSION//./ })
PRE_RELEASE_PARTS=(${CURRENT_VERSION_PARTS[2]//-/ })

#get number parts
VNUM1=${CURRENT_VERSION_PARTS[0]}
VNUM2=${CURRENT_VERSION_PARTS[1]}
VNUM3=${PRE_RELEASE_PARTS[0]}
VNUM4=${PRE_RELEASE_PARTS[1]}

if [[ $VERSION == 'major' ]]
then
  VNUM1=$((VNUM1+1))
elif [[ $VERSION == 'minor' ]]
then
  VNUM2=$((VNUM2+1))
elif [[ $VERSION == 'patch' ]]
then
  VNUM3=$((VNUM3+1))
elif [[ $VERSION == 'pre' ]]
then
  VNUM4=$((VNUM4+1))
else
  echo "No version type (https://semver.org/) or incorrect type specified, try: -v [major, minor, patch, pre]"
  exit 1
fi

# echo "$VNUM1.$VNUM2.$VNUM3 $VNUM4"

#create new tag
# if [ -z "$VNUM4" ] && [$VERSION != 'fix']
if  [ $VERSION != 'pre' ]
then
NEW_TAG="v$VNUM1.$VNUM2.$VNUM3"
else
NEW_TAG="v$VNUM1.$VNUM2.$VNUM3-$VNUM4"
fi

echo -e "New \tVersion: $NEW_TAG"

# while true; do
#     read -p "Do you wish to install this program? " yn
#     case $yn in
#         [Yy]* ) make install; break;;
#         [Nn]* ) exit;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done

# while true; do
# read -p "Are you sure? " yn
# select yn in "Yes" "No"; do
#     case $yn in
#         [Yy]* ) break;;
#         [Nn]* ) exit;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done

echo -e ''

printf 'Create %s-release: %s (y/n)? ' "$VERSION" "$NEW_TAG"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if [ "$answer" != "${answer#[Yy]}" ];then
    echo Yes
else
    echo No
    exit;
fi

#get current hash and see if it already has a tag
# GIT_COMMIT=`git rev-parse HEAD`
# NEEDS_TAG=`git describe --contains $GIT_COMMIT 2>/dev/null`
# NEEDS_TAG=`git tag --sort=committerdate | grep -E '^v[0-9]+.[0-9]+.[0-9]+' | tail -1`

#only tag if no tag already
#to publish, need to be logged in to npm, and with clean working directory: `npm login; git stash`
# if [ -z "$NEEDS_TAG" ]; then
#   echo "Tagged with $NEW_TAG"
# else
#   echo "Already a tag on this commit"
# fi
git tag $NEW_TAG
# git push origin $NEW_TAG

echo Pushed on $NEW_TAG

exit 0