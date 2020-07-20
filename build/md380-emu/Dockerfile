FROM dvswitch_base:0.0.0-base0
RUN apt-get update \
    && apt-get install -y qemu \
    && apt-get clean
COPY ./run.sh /run.sh
EXPOSE 2470
CMD ["/run.sh"]