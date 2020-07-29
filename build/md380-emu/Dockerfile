FROM ubuntu:latest AS builder
ARG repo="https://github.com/DVSwitch/md380tools"
ARG artifact="/dist"
ARG tmp_pkgs="gcc-arm-none-eabi gcc-arm-linux-gnueabi gcc-arm-linux-gnueabihf binutils-arm-none-eabi libnewlib-arm-none-eabi libusb-1.0 python-usb python3-requests make curl git unzip wget"
COPY compile.sh /
RUN apt-get update \
    && apt-get install -y ${tmp_pkgs} \
    && mkdir -p "${artifact}" \
    && git clone ${repo} /src \
    && /compile.sh
    # NOTE: The following cleanup should probably be removed just to expedite 
    # the build process
    # && apt-get purge -y "${tmp_Pkgs}" \
    # && apt-get autoremove -y \
    # && apt-get clean 

FROM ubuntu:latest
COPY ./run.sh /run.sh
COPY --from=builder "/dist/md380-emu" /
RUN apt-get update \
    && apt-get install -y qemu-user-static \
    && chmod +x /run.sh \
    && apt-get clean
CMD ["/run.sh"]