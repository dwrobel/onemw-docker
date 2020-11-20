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
    git clone ssh://dwrobel@gerrit.onemw.net:29418/onemw-harriot
    (cd onemw-harriot && git fetch "ssh://dwrobel@gerrit.onemw.net:29418/onemw-harriot" refs/changes/07/70407/1 && git cherry-pick FETCH_HEAD)
    make -C onemw-harriot/dockerfiles/onemw-mars-18.04 onemw-encrypt-image_1.1-0_amd64.deb
fi

(cd onemw-harriot/dockerfiles/onemw-mars-18.04 && sudo $(which podman || which docker) build -t dwrobel/onemw-ubuntu-1804 .)
sudo $(which podman || which docker) build -t dwrobel/onemw-ubuntu-1804 .
