FROM ubuntu:noble-20250127

ENV DEBIAN_FRONTEND=noninteractive

############################################################
# install dependency packages
RUN apt-get update && apt-get -y install \
        build-essential \
        libreadline-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        libyaml-dev \
        libjemalloc-dev \
        zlib1g-dev \
        rustc \
        curl \
        vim-tiny \
        locales \
        tzdata

############################################################
# install ruby
ARG RUBY_VERSION=3.2.0
ARG BUILD_OPTS=""
RUN curl -L http://ftp.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/ruby-${RUBY_VERSION}.tar.xz | tar Jx \
 && (cd ruby-${RUBY_VERSION} && ./configure --disable-install-doc ${BUILD_OPTS} && make install ) \
 && rm -rf /ruby-${RUBY_VERSION}
RUN gem install bundle

############################################################
# clean apt-get files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

CMD ["bash"]

LABEL vendor     "Neogenia Ltd."
LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"
