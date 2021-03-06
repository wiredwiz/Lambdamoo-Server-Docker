FROM debian:bullseye-20220622
LABEL  org.opencontainers.image.authors="Thaddeus Ryker <thad@edgerunner.org>"
LABEL version="1.8.3"
LABEL description="This is a version 1.8.3 Lambdamoo server that runs the ext-xml (using Expat), Fileio, FUP, pAS9 and WAIF patches"
LABEL patches="ext-xml (using Expat), Fileio, FUP, pAS9 and WAIF"
LABEL core="Lambda"

# build command: 
# docker build --no-cache -f "v1.8.3/Dockerfile.patched.lambda" -t wiredwizard/lambdamoo:1.8.3-Patched .

RUN mkdir -p /home/moo/files
RUN mkdir -p /home/moo/bin
RUN mkdir /home/moo-init
COPY ./v1.8.3/moo.debian.patched /usr/local/bin/moo
COPY ./restart.patched.sh /usr/local/bin/restart
COPY ./LambdaCore/* /home/moo/
COPY ./LambdaCore/* /home/moo-init/

#RUN apt-get update && apt-get install -y procps && rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
RUN chmod +x /usr/local/bin/restart
RUN chmod 777 /usr/local/bin/restart
RUN chmod +x /usr/local/bin/moo
RUN chmod 777 /usr/local/bin/moo

ENV TZ="America/New_York"
ENV PORT="8888"
EXPOSE ${PORT}/tcp

STOPSIGNAL SIGINT

WORKDIR /home/moo
ENTRYPOINT ["/tini", "-g", "-v", "--"]
CMD ["sh", "-c", "restart moo $PORT"]