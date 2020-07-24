FROM ubuntu:focal AS analog_builder
ARG platform="amd64"
ARG repo_base="https://github.com/DVSwitch"
ARG analog_name="Analog_Bridge"
ARG mmdvm_name="MMDVM_Bridge"
ARG tmp_pkgs="git"
ARG pkgs="libsndfile-dev libasound2 python3"
ENV DEBIAN_FRONTEND=noninteractive
COPY run.sh /
COPY *.tmpl /
COPY bridge.macro /
RUN apt-get update \
    && apt-get install -y ${tmp_pkgs} ${pkgs} \
    && git clone ${repo_base}/${analog_name} /src/${analog_name} \
    && git clone ${repo_base}/${mmdvm_name} /src/${mmdvm_name} \
    && mv /src/${analog_name}/bin/${analog_name}.${platform} /${analog_name} \
    && mv /src/${mmdvm_name}/dvswitch.sh / \
    && mkdir -p /opt/${mmdvm_Name} \
    && ln -s /DVSwitch.ini /opt/${mmdvm_name}/DVSwitch.ini \
    && apt-get purge -y ${tmp_pkgs} \
    && apt-get autoremove -y
# TODO: Sniff the traffic to determine which protocols are used for each of 
# these ports and modify the expose configs to reflect
EXPOSE 2460/tcp
EXPOSE 2460/udp
EXPOSE 31100/tcp
EXPOSE 31100/udp
EXPOSE 34001/tcp
EXPOSE 34001/udp
EXPOSE 50111/tcp
EXPOSE 50111/udp
CMD ["/run.sh"]