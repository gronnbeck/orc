FROM gitpod/workspace-full

USER root

RUN apt-get update && apt-get install -y haskell-platform
RUN curl -sSL https://get.haskellstack.org/ | sh

USER gitpod

RUN mkdir -p $HOME/.stacktmp && cd $HOME/.stacktmp && \
    git clone https://github.com/haskell/haskell-ide-engine --recurse-submodules && \
    cd haskell-ide-engine && \
    rm -rf $HOME/.stacktmp
