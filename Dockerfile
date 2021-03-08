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
RUN chown -R cardano:cardano /home/cardano
USER cardano
ARG DOWNLOADS=/home/cardano/downloads
RUN mkdir $DOWNLOADS
RUN wget https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz -P $DOWNLOADS
RUN tar -xf $DOWNLOADS/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz -C $DOWNLOADS
RUN mkdir -p ~/.local/bin
RUN mv $DOWNLOADS/cabal ~/.local/bin/
RUN echo export PATH="~/.local/bin:$PATH" >> ~/.bashrc
WORKDIR /home/cardano
CMD ["/bin/bash"]