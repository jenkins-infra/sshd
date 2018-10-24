FROM debian:stable AS base

LABEL \
  MAINTAINER="infra@lists.jenkins-ci.org"\
  DESCRIPTION="This image runs a sshd server"

EXPOSE 22

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod 0755 /tini

RUN \
  apt-get update && \
  apt-get install -y openssh-server vim && \
  mkdir /run/sshd/ && \
  apt-get clean && \
  find /var/lib/apt/lists -type f -delete

COPY config/sshd_config /etc/ssh/sshd_config

ENTRYPOINT [\
  "/tini", "--", \
  "/usr/sbin/sshd",\
  "-D", "-e", \
  "-f","/etc/ssh/sshd_config"\
  ]

### Evergreen Builder

FROM base AS evergreen
LABEL \
  DESCRIPTION="This image is used as ssh gateway for evergreen contributors"

RUN \
  apt-get update && \
  apt-get install -y postgresql-client && \
  apt-get clean && \
  find /var/lib/apt/lists -type f -delete

COPY config/authorized_keys /tmp
COPY users.evergreen /tmp/users
RUN \
  while read user ; do \
  useradd -m -d /home/$user -s /bin/bash $user ; \
  mkdir /home/$user/.ssh ; \
  mv /tmp/$user /home/$user/.ssh/authorized_keys ;\
  chown $user:$user -R /home/$user ; \
  done < /tmp/users && \
  rm /tmp/users

