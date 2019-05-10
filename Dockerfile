#
# Dockerfile for shadowsocks-libev
#


FROM alpine
LABEL maintainer="ibmzos <ibmzos@hotmail.com>"


#ENV SERVER_ADDR 159.89.137.123
ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 18721
ENV PASSWORD="aifuto"
ENV METHOD aes-256-cfb
ENV TIMEOUT 600
ENV DNS_ADDRS 8.8.8.8,8.8.4.4
ENV ARGS=


COPY . /tmp/repo
COPY ./config/server.json /etc
RUN set -ex \
# Build environment setup
&& apk add --no-cache --virtual .build-deps \
autoconf \
automake \
build-base \
c-ares-dev \
libev-dev \
libtool \
libsodium-dev \
linux-headers \
mbedtls-dev \
pcre-dev \
# Build & install
&& cd /tmp/repo \
&& ./autogen.sh \
&& ./configure --prefix=/usr --disable-documentation \
&& make install \
&& apk del .build-deps \
# Runtime dependencies setup
&& apk add --no-cache \
rng-tools \
$(scanelf --needed --nobanner /usr/bin/ss-* \
| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
| sort -u) \
&& rm -rf /tmp/repo


USER nobody


CMD exec ss-server -c /etc/server.json
# CMD exec ss-server \
# -s ${SERVER_ADDR} \
# -p ${SERVER_PORT} \
# -k ${PASSWORD} \
# -m ${METHOD} \
# -t ${TIMEOUT} \
# -l 1080 \
# -d ${DNS_ADDRS}
# -u
# ${ARGS}

