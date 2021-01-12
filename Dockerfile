#
# Copyright 2018-2020 Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
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

FROM dwrobel/onemw-ubuntu-1804

USER root:root

RUN userdel onemw-builder

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo ccache mc strace

RUN echo >/etc/sudoers.d/sudo-no-passwd '%sudo  ALL=(ALL)       NOPASSWD: ALL'

ADD utils/onemw-gerrit.sh /usr/local/bin/

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
