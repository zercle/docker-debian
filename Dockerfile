# base on Debian current stable image
FROM debian:stable-slim
LABEL maintainer="Kawin Viriyaprasopsook <kawin.vir@zercle.tech>"

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ARG DOCKER_TIMEZONE="Asia/Bangkok"

ENV TERM="xterm" \
    DEBIAN_FRONTEND="${DEBIAN_FRONTEND}" \
    LANGUAGE="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="${DOCKER_TIMEZONE}"

# copy sources
COPY sources.list /etc/apt/

# install base packages
RUN set -ex;\
    echo "**** install apt-utils and locales ****" && \
    apt-get update && \
    apt-get -y install apt-utils locales tzdata && \
    echo "**** generate locale ****" && \
    sed -i "s/# th_TH.UTF-8/th_TH.UTF-8/" /etc/locale.gen && \
    sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && \
    locale-gen && \
    update-locale en_US.UTF-8 && \
    echo "**** set timezone ****" && \
    echo ${DOCKER_TIMEZONE} > /etc/timezone && \
    cp /usr/share/zoneinfo/${DOCKER_TIMEZONE} /etc/localtime && \
    dpkg-reconfigure tzdata && \
    echo "**** install basic packages ****" && \
    apt-get -y install curl wget jq net-tools nano dnsutils ca-certificates gnupg && \
    echo "**** update OS ****" && \
    apt-get -y dist-upgrade && \
    echo "**** cleanup ****" && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# update image on each build from this image
# ONBUILD RUN set -ex;\
#     echo "**** update OS ****" && \
#     apt-get update && \
#     apt-get -y dist-upgrade && \
#     echo "**** cleanup ****" && \
#     apt-get -y autoremove && \
#     apt-get -y clean && \
#     rm -rf \
#     /tmp/* \
#     /var/lib/apt/lists/* \
#     /var/tmp/*

CMD ["bash"]
