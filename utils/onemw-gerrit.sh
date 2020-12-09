#!/bin/bash
#
# Author: Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
# Version: v0.1
#
# It assumes you have in the ~/.ssh/config
# Host gerrit.onemw.net
#    User <your-user-name>
#

set -e

find_latest_change () {
  local remote=$1
  local review=$2
  git ls-remote $remote | grep -E "refs/changes/[[:digit:]]+/$2/" | sort -t / -k 5 -g | tail -n1 | awk '{print $2}'
}

IFS=: read -a args <<< $1
project=${args[0]}
changeset=${args[1]}

remote=ssh://gerrit.onemw.net:29418/$project
latest=$(find_latest_change $remote $changeset)

num=$(echo $latest | sed "sX/X\ Xg" | awk '{print $5}')
echo "DEPS=${project}:${changeset}/${num}"

echo "git fetch $remote $latest && git cherry-pick FETCH_HEAD"
git fetch $remote $latest && git cherry-pick FETCH_HEAD
