#!/bin/sh
#
# Copyright (C) 2020 Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
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

if [ ! -d onemw-harriot ]; then
    git clone ssh://gerrit.onemw.net:29418/onemw-harriot
fi

(cd onemw-harriot/dockerfiles/onemw-mars-u18.04 && rm -rf common; cp -a ../common .)
make -C onemw-harriot/dockerfiles/onemw-mars-u18.04 prepare

OCI_BUILDER=$(which podman 2>/dev/null || which docker 2>/dev/null)

if [ "x${OCI_BUILDER}" = "x" ]; then
    echo "ERROR: Could not find neither podman nor docker."
    exit 1
fi

sudo ${OCI_BUILDER} image rm -f localhost/dwrobel/onemw-ubuntu-1804 || true
sudo ${OCI_BUILDER} image rm -f localhost/dwrobel/onemw-ubuntu-1804-wrapper || true

(cd onemw-harriot/dockerfiles/onemw-mars-u18.04 && sudo ${OCI_BUILDER} build -t dwrobel/onemw-ubuntu-1804 .)
sudo ${OCI_BUILDER} build -t dwrobel/onemw-ubuntu-1804-wrapper .
