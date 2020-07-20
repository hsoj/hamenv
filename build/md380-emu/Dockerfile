FROM dvswitch:0.0.0
RUN apt-get update \
    && apt-get install -y qemu \
    && apt-get clean
COPY ./run.sh /run.sh
EXPOSE 2470
CMD ["/run.sh"]