FROM ubuntu:latest
LABEL  org.opencontainers.image.authors="Thaddeus Ryker <thad@edgerunner.org>"
LABEL version="1.8.1"
LABEL description="This is a fairly patched version 1.8.1 Lambdamoo server that runs the ext-xml (using Expat), Fileio, FUP, pAS5, pAS9 and WAIF patches"
LABEL patches="ext-xml (using Expat), Fileio, FUP, pAS5, pAS9 and WAIF"
EXPOSE 8888/tcp

RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
#RUN apt-get install -yq csh    

RUN mkdir -p /home/moo/files
COPY ./moo /usr/local/bin/moo
COPY ./restart.sh /usr/local/bin/restart.sh
COPY ./data/* /home/moo/

WORKDIR /home/moo
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["moo -l moo.log moo.db moo.db.new 8888"]