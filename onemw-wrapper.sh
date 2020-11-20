#!/bin/bash -xe
#
# Copyright 2018 Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Wraps commands with docker
#
# Usage: docker-wrapper.sh <command-to-execute-within-container>
#
# Note: It has also access to the entire $HOME directory

CWD=$PWD

if [ $# -lt 1 ]; then
    set +x
    echo ""
    echo "docker/podman wrapper by Damian Wrobel <dwrobel@ertelnet.rybnik.pl>"
    echo ""
    echo "      Usage: $0 <command-to-execute-within-container>"
    echo "    Example: $0 bash"
    echo ""
    exit 1
fi


function follow_links() (
  cd -P "$(dirname -- "$1")"
  file="$PWD/$(basename -- "$1")"
  while [[ -h "$file" ]]; do
    cd -P "$(dirname -- "$file")"
    file="$(readlink -- "$file")"
    cd -P "$(dirname -- "$file")"
    file="$PWD/$(basename -- "$file")"
  done
  echo "$file"
)

PROG_NAME="$(follow_links "${BASH_SOURCE[0]}")"
DIRECTORY="$(cd "${PROG_NAME%/*}" ; pwd -P)"
DOCKER_CMD=$(which podman || which docker)

config_file="${DW_CONFIG_PATH:-${HOME}/.config/docker-wrapper.sh/dw-config.conf}"

if [ -e "${config_file}" ]; then
    # Allows to specify additional options to docker build/run commands
    # DOCKER_BUILD=("--pull=false")
    # DOCKER_RUN=("-v" "/data:/data")
    source "${config_file}"
fi

if [ -z "${DOCKER_IMG}" ]; then
    DOCKER_IMG=dwrobel/onemw-ubuntu-1804-wrapper
    sudo ${DOCKER_CMD} build --network=host "${DOCKER_BUILD[@]}" -t ${DOCKER_IMG} $DIRECTORY
fi

VDIR="$HOME"

if [ -n "${DISPLAY}" ]; then
    display_opts="-e DISPLAY=$DISPLAY"
fi

if [ -n "${WAYLAND_DISPLAY}" ]; then
    wayland_display_opts="-e WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
fi

if [ -n "${XDG_RUNTIME_DIR}" ]; then
    xdg_runtime_opts="-e XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR} -v ${XDG_RUNTIME_DIR}:${XDG_RUNTIME_DIR}"
fi

if [ -n "${CC}" ]; then
    cc_opts="-e CC=$CC"
fi

if [ -n "${CXX}" ]; then
    cxx_opts="-e CXX=$CXX"
fi

if [ -n "${SEMAPHORE_CACHE_DIR}" ]; then
    cache_dir="-e CACHE_DIR=$SEMAPHORE_CACHE_DIR"
fi

test -t 1 && USE_TTY="-t"

sudo ${DOCKER_CMD} run --network=host "${DOCKER_RUN[@]}" --entrypoint=/entrypoint.sh --privileged -p 3389:3389 -v /dev/dri:/dev/dri -i ${USE_TTY} ${cache_dir} ${cc_opts} ${cxx_opts} ${wayland_display_opts} -e USER=$USER -e UID=$UID -e GID=$(id -g $USER) -e CWD="$CWD" ${display_opts} ${xdg_runtime_opts} -v /tmp/.X11-unix:/tmp/.X11-unix -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v "${VDIR}":"${VDIR}" ${DOCKER_IMG} "$@"
