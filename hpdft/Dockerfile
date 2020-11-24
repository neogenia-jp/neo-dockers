FROM haskell:8.10.2-buster

LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

WORKDIR /root

RUN git clone https://github.com/k16shikano/hpdft.git \
 && cd hpdft \
 && cabal update \
 && cabal install

