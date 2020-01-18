FROM gitpod/workspace-full

USER root

RUN apt-get update && apt-get install -y haskell-platform
RUN curl -sSL https://get.haskellstack.org/ | sh

USER gitpod