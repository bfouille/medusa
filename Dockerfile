FROM lsiobase/alpine:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MEDUSA_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs,aptalca"

ENV LANG='en_US.UTF-8'

RUN \
 echo -e "**** install app ****"
 
RUN \
 echo -e "${MEDUSA_RELEASE}"
RUN \
 echo -e "${MEDUSA_RELEASE+x}"
RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	mediainfo \
	python3 \
	unrar 
	
	
# Medusa	
RUN \
 echo "**** install app ****" && \
 if [ -z ${MEDUSA_RELEASE+x} ]; then \
	MEDUSA_RELEASE=$(curl -sX GET "https://api.github.com/repos/pymedusa/Medusa/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 mkdir -p \
	/app/medusa && \
 curl -o \
	/tmp/medusa.tar.gz -L \
	"https://github.com/pymedusa/Medusa/archive/${MEDUSA_RELEASE}.tar.gz" && \
 tar xf /tmp/medusa.tar.gz -C \
	/app/medusa --strip-components=1

# CouchPotato
RUN \
 echo "**** install app ****" && \
 mkdir -p \
	/app/couchpotato && \
 if [ -z ${COUCHPOTATO_RELEASE+x} ]; then \
 	COUCHPOTATO_RELEASE=$(curl -sX GET "https://api.github.com/repos/CouchPotato/CouchPotatoServer/commits/master" \
        | awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
	/tmp/couchpotato.tar.gz -L \
	"https://github.com/CouchPotato/CouchPotatoServer/archive/${COUCHPOTATO_RELEASE}.tar.gz" && \
 tar xf /tmp/couchpotato.tar.gz -C \
	/app/couchpotato --strip-components=1 && \
 echo "**** Cleanup ****" && \
 rm -Rf /tmp/*



# copy local files
COPY root/ /

# ports and volumes
EXPOSE 5050
EXPOSE 8081

WORKDIR /app/couchpotato

VOLUME /config /downloads /tv
