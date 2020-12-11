#!/bin/sh

# Copyright (C) 2020 Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

if [ ! -d onemw-harriot ]; then
    git clone ssh://gerrit.onemw.net:29418/onemw-harriot
fi

make -C onemw-harriot/dockerfiles/onemw-mars-18.04 prepare

OCI_BUILDER=$(which podman 2>/dev/null || which docker 2>/dev/null)

if [ "x${OCI_BUILDER}" = "x" ]; then
    echo "ERROR: Could not find neither podman nor docker."
    exit 1
fi

sudo ${OCI_BUILDER} localhost/dwrobel/onemw-ubuntu-1804 || true
sudo ${OCI_BUILDER} localhost/dwrobel/onemw-ubuntu-1804-wrapper || true

(cd onemw-harriot/dockerfiles/onemw-mars-18.04 && sudo ${OCI_BUILDER} build -t dwrobel/onemw-ubuntu-1804 .)
sudo ${OCI_BUILDER} build -t dwrobel/onemw-ubuntu-1804-wrapper .
