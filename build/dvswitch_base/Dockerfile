FROM ubuntu:19.10 as BUILDER
ARG pkgs="software-properties-common"
ARG apt_repo=http://dvswitch.org/ASL_Repository
RUN apt-get update \
	&& apt-get install ${pkgs} \
	&& add-apt-repository ${apt_repo} \
	&& apt-get update \
	&& apt-get install dvswitch \
	&& apt-get purge ${pkgs} \
	&& apt-get clean
