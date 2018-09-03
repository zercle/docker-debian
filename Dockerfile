# Debian 9
FROM debian:stable-slim
LABEL maintainer="Kawin Viriyaprasopsook <bouroo@gmail.com>"

ARG	timezone=Asia/Bangkok
ENV	TERM xterm
ENV	DEBIAN_FRONTEND noninteractive

ENV	LANG en_US.UTF-8
ENV	LC_ALL en_US.UTF-8
ENV	TZ $timezone

# Change locale
RUN apt-get update && apt-get -y install locales tzdata \
	&& locale-gen en_US.UTF-8 && locale-gen th_TH.UTF-8 \
	&& update-locale en_US.UTF-8 \
	&& echo $timezone > /etc/timezone \
	&& cp /usr/share/zoneinfo/$timezone /etc/localtime \
	&& dpkg-reconfigure tzdata

# Add basic package
RUN	apt-get update && apt-get -y dist-upgrade
RUN	apt-get -y install \
	apt-transport-https \
	apt-utils \
	cron \
	curl \
	dnsutils \
	htop \
	iputils-ping \
	genisoimage \
	git \
	gnupg \
	lsb-release \
	nano \
	net-tools \
	openssl \
	pwgen \
	software-properties-common \
	traceroute \
	wget \
	unattended-upgrades \
	gnupg \
	zsh \
	&& apt-get autoclean

RUN echo 'APT::Periodic::Update-Package-Lists "1";' > /etc/apt/apt.conf.d/20auto-upgrades \
	&& echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/20auto-upgrades

COPY ./files /

CMD ["bash"]
