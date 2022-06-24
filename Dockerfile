FROM debian:bullseye-20220622
LABEL  org.opencontainers.image.authors="Thaddeus Ryker <thad@edgerunner.org>"
LABEL version="1.8.1"
LABEL description="This is a fairly patched version 1.8.1 Lambdamoo server that runs the ext-xml (using Expat), Fileio, FUP, pAS5, pAS9 and WAIF patches"
LABEL patches="ext-xml (using Expat), Fileio, FUP, pAS5, pAS9 and WAIF"
EXPOSE 8888/tcp

RUN mkdir -p /home/moo/files
RUN mkdir /home/moo-init
COPY ./moo /usr/local/bin/moo
COPY ./restart.sh /usr/local/bin/restart
COPY ./data/* /home/moo/
COPY ./data/* /home/moo-init/

RUN apt-get update && apt-get install -y procps && rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
RUN chmod +x /usr/local/bin/restart
RUN chmod 777 /usr/local/bin/restart
RUN chmod +x /usr/local/bin/moo
RUN chmod 777 /usr/local/bin/moo

ENV TZ="America/New_York"

STOPSIGNAL SIGINT

WORKDIR /home/moo
ENTRYPOINT ["/tini", "-g", "-v", "--"]
CMD ["restart", "moo", "8888"]