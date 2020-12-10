FROM dwrobel/onemw-ubuntu-1804

USER root:root

RUN userdel onemw-builder

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo ccache mc strace

RUN echo >/etc/sudoers.d/sudo-no-passwd '%sudo  ALL=(ALL)       NOPASSWD: ALL'

ADD utils/onemw-gerrit.sh /usr/local/bin/

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
