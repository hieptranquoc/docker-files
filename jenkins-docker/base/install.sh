#!/bin/bash
set -ex; \
\
apt-get update -qy \
&& apt-get install -q -y \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    software-properties-common \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
; \
\
# Test version is no support('rc' version)
if [[ "$DOCKER_VERSION" == *"rc"* ]]; then \
    echo >&2 'error: test version is no support'; \
    exit 1; \
fi; \
\
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -; \
apt-key fingerprint 0EBFCD88; \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
  $DOCKER_CHANNEL"; \
apt-get update -qy; \
\
if [[ "$DOCKER_VERSION" == "latest" ]]; then \
   apt-get -qy install docker-ce docker-ce-cli containerd.io; \
else \
  INSTALL_VERSION=$(apt-cache madison docker-ce | grep "$DOCKER_VERSION" | head -1 | cut -d '|' -f2 | tr -d '[:space:]'); \
  \
  if [[ -n "$INSTALL_VERSION" ]]; then \
      apt-get install -q -y docker-ce=$INSTALL_VERSION docker-ce-cli=$INSTALL_VERSION containerd.io; \
  else \
      echo >&2 "error: unknown '${DOCKER_VERSION}' version"; \
      exit 1; \
  fi; \
  \
fi; \
