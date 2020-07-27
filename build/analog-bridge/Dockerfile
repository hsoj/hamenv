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
    && apt-get purge -y ${tmp_pkgs} \
    && apt-get autoremove -y
CMD ["bash", "-c", "/run.sh"]