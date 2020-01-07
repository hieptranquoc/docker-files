ARG JENKINS_VERSION=lts

FROM jenkins/jenkins:$JENKINS_VERSION

LABEL authors="hieptranquoc <hieptq8888@gmail.com>"

# add more arguments from CI to the image so that `$ env` should reveal more info
ARG CI_BUILD_ID
ARG CI_BUILD_REF
ARG CI_REGISTRY_IMAGE
ARG CI_BUILD_TIME

ENV CI_BUILD_ID=$CI_BUILD_ID CI_BUILD_REF=$CI_BUILD_REF CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE \
  CI_BUILD_TIME=$CI_BUILD_TIME

USER root

ARG ARCH="amd64"
ARG DOCKER_CHANNEL="stable"
ARG DOCKER_VERSION="latest"

ADD install.sh ./install.sh
RUN chmod +x ./install.sh
RUN ./install.sh

COPY docker-entrypoint.sh /usr/local/bin/

# https://github.com/docker-library/docker/pull/166
#   dockerd-entrypoint.sh uses DOCKER_TLS_CERTDIR for auto-generating TLS certificates
#   docker-entrypoint.sh uses DOCKER_TLS_CERTDIR for auto-setting DOCKER_TLS_VERIFY and DOCKER_CERT_PATH
# (For this to work, at least the "client" subdirectory of this path needs to be shared between the client and server containers via a volume, "docker cp", or other means of data sharing.)
ENV DOCKER_TLS_CERTDIR=/certs

RUN mkdir /certs /certs/client && chmod 1777 /certs /certs/client

RUN gpasswd -a jenkins docker

USER jenkins

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
