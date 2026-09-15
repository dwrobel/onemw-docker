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

FROM quay.io/centos/centos:stream9
#https://hub.docker.com/r/almalinux/9-base
#FROM quay.io/almalinuxorg/9-base

RUN dnf install -y sudo https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

RUN dnf install -y sudo
RUN echo >/etc/sudoers.d/wheel-no-passwd '%wheel	ALL=(ALL)	NOPASSWD: ALL'

RUN dnf install -y dnf-plugins-core rpm-build
RUN dnf config-manager --set-enabled crb
RUN dnf copr enable -y dwrobel/tar centos-stream-9
RUN dnf copr enable -y dwrobel/repo centos-stream-9
RUN dnf update -y

RUN dnf install -y bzip2 ccache chrpath cpio cpp diffstat diffutils file findutils gawk gcc gcc-c++ git glibc-devel glibc-langpack-en gzip hostname libacl lz4 make patch perl perl-Data-Dumper perl-File-Compare perl-File-Copy perl-FindBin perl-Text-ParseWords perl-Thread-Queue perl-bignum perl-locale python python3 python3-GitPython python3-jinja2 python3-pexpect python3-pip rpcgen socat tar texinfo unzip wget which xz zstd
RUN dnf install -y git which strace diffutils quilt mc repo

#RUN curl -sL https://download.copr.fedorainfracloud.org/results/dwrobel/tar/epel-7-x86_64/01752524-tar/tar-1.32-6.el7.x86_64.rpm | rpm2archive | tar -C / -zxvf - ./usr/bin/tar

ADD entrypoint.sh /
