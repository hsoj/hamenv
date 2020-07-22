FROM ubuntu:latest
ARG repo="https://github.com/travisgoodspeed/md380tools.git"
ARG artifact="/dist"
ARG tmp_pkgs="gcc-arm-none-eabi gcc-arm-linux-gnueabi binutils-arm-none-eabi libnewlib-arm-none-eabi libusb-1.0 python-usb python3-requests make curl git unzip wget"
COPY compile.sh /
RUN apt-get update \
    && apt-get install -y ${tmp_pkgs} \
    && mkdir -p "${artifact}" \
    && git clone ${repo} /src \
    # && /src/firmware/test_ok.sh \
    # Cleanup
    # && apt-get purge -y ${tmp_pkgs} \
    # && apt-get autoremove -y \
    # && apt-get clean