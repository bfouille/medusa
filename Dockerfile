FROM lsiobase/alpine:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MEDUSA_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs,aptalca"

ENV LANG='en_US.UTF-8'

ENV SMA_PATH /usr/local/sma
ENV SMA_RS Sonarr
ENV SMA_UPDATE false


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
	unrar \
	git \
	wget 
	# && \
 # apk update && \
 # apk upgrade 
	
	
# Medusa	
RUN \
 echo "**** install app ****" 
 #&& \
RUN \
MEDUSA_RELEASE=$(curl -sX GET "https://api.github.com/repos/pymedusa/Medusa/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]'); 
RUN \
echo -e "$MEDUSA_RELEASE" 
RUN \
mkdir -p /app/medusa
RUN \
curl -o \
	/tmp/medusa.tar.gz -L \
	"https://github.com/pymedusa/Medusa/archive/$MEDUSA_RELEASE.tar.gz" 
RUN \
	tar xf /tmp/medusa.tar.gz -C /app/medusa --strip-components=1 

RUN \
# make directory
  mkdir ${SMA_PATH} && \
# download repo
  git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git ${SMA_PATH}
  
RUN \
# install pip, venv, and set up a virtual self contained python environment
  python3 -m pip install --user --upgrade pip && \
  python3 -m pip install --user virtualenv && \
  python3 -m virtualenv ${SMA_PATH}/venv
  
RUN \
  ${SMA_PATH}/venv/bin/pip install -r ${SMA_PATH}/setup/requirements.txt 
  
RUN \
# ffmpeg
  wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz -O /tmp/ffmpeg.tar.xz && \
  tar -xJf /tmp/ffmpeg.tar.xz -C /usr/local/bin --strip-components 1 && \
  chgrp users /usr/local/bin/ffmpeg && \
  chgrp users /usr/local/bin/ffprobe && \
  chmod g+x /usr/local/bin/ffmpeg && \
  chmod g+x /usr/local/bin/ffprobe


# copy local files
COPY root/ /
COPY extras/ ${SMA_PATH}/

# ports and volumes

EXPOSE 8081

VOLUME /usr/local/sma/config
VOLUME /config /downloads /tv
