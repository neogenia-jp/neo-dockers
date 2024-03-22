#FROM fluent/fluentd:v0.14-debian
FROM ruby:2.5.0

LABEL Vendor     "Neogenia Ltd."
LABEL maintainer "Wataru Maeda <w.maeda@neogenia.co.jp>"

ENV DEBIAN_FRONTEND=noninteractive

RUN gem install --no-ri --no-rdoc \
        fluentd:1.1.0 \
        fluent-plugin-elasticsearch \
        fluent-plugin-parser

RUN fluentd --setup /etc/fluentd

ADD resources/fluent.conf /etc/fluentd/fluent.conf

CMD fluentd -c /etc/fluentd/fluent.conf

