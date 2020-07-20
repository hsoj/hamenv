FROM ubuntu:19.10 as BUILDER
ARG pkgs="wget software-properties-common"
ARG apt_repo="'deb http://dvswitch.org/ASL_Repository stretch hamradio'"
RUN apt-get update \
	&& apt-get install -y ${pkgs} \
	&& wget -O /gpg.key http://dvswitch.org/ASL_Repository/dvswitch.gpg.key \
	&& apt-key add /gpg.key \
	&& rm -f /gpg.key \
	&& add-apt-repository 'deb http://dvswitch.org/ASL_Repository stretch hamradio' \
	&& apt-get update \
	&& apt-get install -y dvswitch \
	&& apt-get purge -y ${pkgs} \
	&& apt-get autoremove -y \
	&& apt-get clean 
