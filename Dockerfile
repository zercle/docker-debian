# From Debian current stable image
FROM	debian:stable-slim
LABEL	maintainer="Kawin Viriyaprasopsook <kawin.vir@zercle.tech>"

ARG	timezone=Asia/Bangkok
ENV	TERM xterm
ENV	DEBIAN_FRONTEND noninteractive

ENV	LANG en_US.UTF-8
ENV	LC_ALL en_US.UTF-8
ENV	TZ $timezone

# Change locale
RUN	apt-get update && apt-get -y install locales tzdata \
	&& sed -i "s/# th_TH.UTF-8/th_TH.UTF-8/" /etc/locale.gen \
	&& sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
	&& locale-gen \
	&& update-locale en_US.UTF-8 \
	&& echo $timezone > /etc/timezone \
	&& cp /usr/share/zoneinfo/$timezone /etc/localtime \
	&& dpkg-reconfigure tzdata

COPY	./files /

# Add basic package
RUN	apt-get update && apt-get -y dist-upgrade \
	&& apt-get -y install \
	apt-transport-https \
	apt-utils \
	cron \
	curl \
	dnsutils \
	genisoimage \
	git \
	gnupg \
	lsb-release \
	mtr-tiny \
	nano \
	net-tools \
	openssl \
	pwgen \
	software-properties-common \
	wget \
	unattended-upgrades \
	gnupg \
	&& apt-get autoclean \
	&& echo 'APT::Periodic::Update-Package-Lists "1";' > /etc/apt/apt.conf.d/20auto-upgrades \
	&& echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/20auto-upgrades

CMD	["bash"]
