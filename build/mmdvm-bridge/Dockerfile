FROM ubuntu:focal AS mmdvm_builder
ARG dist_path="/dist"
ARG platform="amd64"
ARG repo_base="https://github.com/DVSwitch"
ARG repo_mmdvm="MMDVM_Bridge"
ARG tmp_pkgs="git"
COPY *.tmpl /
COPY run.sh /
RUN apt-get update \
    && apt-get install -y ${tmp_pkgs} \
    && git clone ${repo_base}/${repo_mmdvm} /src/${repo_mmdvm} \
    && mv /src/${repo_mmdvm}/bin/${repo_mmdvm}.${platform} /${repo_mmdvm} \
    && mkdir -p /opt/${repo_mmdvm} \
    && mv /src/${repo_mmdvm}/dvswitch.sh / \
    && chmod +x /run.sh /dvswitch.sh \
    && apt-get purge -y ${tmp_pkgs} \
    && apt-get autoremove -y \
    && apt-get clean
CMD ["bash", "/run.sh"]