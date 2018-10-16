FROM debian:stable

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
