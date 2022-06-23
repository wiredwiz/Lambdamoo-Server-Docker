FROM debian:latest
LABEL  org.opencontainers.image.authors="Thaddeus Ryker <thad@edgerunner.org>"
LABEL version="1.8.1"
LABEL description="This is a fairly patched version 1.8.1 Lambdamoo server that runs the ext-xml (using Expat), Fileio, FUP, pAS5, pAS9 and WAIF patches"
LABEL patches="ext-xml (using Expat), Fileio, FUP, pAS5, pAS9 and WAIF"
EXPOSE 8888/tcp

ENV TZ="America/New_York"

RUN mkdir -p /home/moo/files
COPY ./moo /usr/local/bin/moo
COPY ./restart.sh /usr/local/bin/restart
COPY ./data/* /home/moo/

WORKDIR /home/moo
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["restart moo 8888"]