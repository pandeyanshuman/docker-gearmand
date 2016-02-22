FROM debian:jessie

RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
	&& rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
#RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
#RUN curl -o /usr/local/bin/gosu -fSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" \
#	&& curl -o /usr/local/bin/gosu.asc -fSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture).asc" \
#	&& gpg --verify /usr/local/bin/gosu.asc \
#	&& rm /usr/local/bin/gosu.asc \
#	&& chmod +x /usr/local/bin/gosu

ENV GEARMAN_VERSION 1.1.12
ENV GEARMAN_DOWNLOAD_URL https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz
ENV GEARMAN_DOWNLOAD_MD5 99dd0be85b181eccf7fb1ca3c2a28a9f

RUN buildDeps='gcc libc6-dev make g++ gperf libboost-dev libboost-program-options-dev libevent-dev uuid-dev libmysqlclient-dev' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/src/gearmand \
	&& curl -sSL "$GEARMAN_DOWNLOAD_URL" -o gearmand.tar.gz \
	&& echo "$GEARMAN_DOWNLOAD_MD5 *gearmand.tar.gz" | md5sum -c - \
	&& tar -xzf gearmand.tar.gz -C /usr/src/gearmand --strip-components=1 \
	&& rm gearmand.tar.gz \
  && cd /usr/src/gearmand \
  && ./configure \
	&& make \
	&& make install \
  && cd / \
	&& rm -r /usr/src/gearmand
#	&& apt-get purge -y --auto-remove $buildDeps

RUN mkdir /data

VOLUME /data
WORKDIR /data

EXPOSE 4730
CMD [ "gearmand", "--verbose=DEBUG" ]
