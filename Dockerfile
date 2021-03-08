# CARDANO DOCS: https://docs.cardano.org/projects/cardano-node/en/latest/
FROM ubuntu:18.04 AS base
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install sudo vim wget automake build-essential \
    pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev \
    libsystemd-dev zlib1g-dev make g++ tmux git jq wget \
    libncursesw5 libtool autoconf -y

RUN groupadd -r cardano && useradd -g cardano cardano && usermod -a -G sudo cardano
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir /home/cardano
RUN cp /root/.bashrc /home/cardano/.bashrc

ARG DOWNLOADS=/home/cardano/downloads
ARG CARDANO_NODE=/home/cardano/cardano-node
RUN mkdir ${DOWNLOADS}
RUN mkdir ${CARDANO_NODE}

COPY config/configuration.yaml ${CARDANO_NODE}/configuration.yaml
COPY config/genesis.json ${CARDANO_NODE}/genesis.json
COPY config/topology.json ${CARDANO_NODE}/topology.json
RUN mkdir ${CARDANO_NODE}/relay
RUN touch ${CARDANO_NODE}/relay/db
RUN touch ${CARDANO_NODE}/relay/node.socket

RUN chown -R cardano:cardano /home/cardano

USER cardano

RUN wget https://hydra.iohk.io/build/5735143/download/1/cardano-node-1.25.0-linux.tar.gz -P ${DOWNLOADS}
RUN tar -xf ${DOWNLOADS}/cardano-node-1.25.0-linux.tar.gz -C ${CARDANO_NODE}

RUN wget https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz -P ${DOWNLOADS}
RUN tar -xf ${DOWNLOADS}/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz -C ${DOWNLOADS}
RUN mkdir -p ~/.local/bin
RUN mv ${DOWNLOADS}/cabal ~/.local/bin/
RUN echo export PATH="~/.local/bin:$PATH" >> ~/.bashrc

#RUN wget https://downloads.haskell.org/~ghc/9.0.1/ghc-9.0.1-x86_64-deb10-linux.tar.xz -P ${DOWNLOADS}
#RUN tar -xf ${DOWNLOADS}/ghc-9.0.1-x86_64-deb10-linux.tar.xz -C ${DOWNLOADS}
#RUN rm ${DOWNLOADS}/ghc-9.0.1-x86_64-deb10-linux.tar.xz
#RUN cd ${DOWNLOADS}/ghc-9.0.1 && ./configure
#RUN cd ${DOWNLOADS}/ghc-9.0.1 && sudo make install

#RUN cd ${DOWNLOADS} && git clone https://github.com/input-output-hk/libsodium
#RUN cd ${DOWNLOADS}/libsodium && git checkout 675149b9b8b66ff44152553fb3ebf9858128363d
#RUN cd ${DOWNLOADS}/libsodium && ./autogen.sh
#RUN cd ${DOWNLOADS}/libsodium && ./configure
#RUN cd ${DOWNLOADS}/libsodium && make
#RUN cd ${DOWNLOADS}/libsodium && sudo make install

WORKDIR /home/cardano
CMD ["/bin/bash"]
