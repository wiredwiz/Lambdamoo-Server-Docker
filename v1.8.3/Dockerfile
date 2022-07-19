FROM debian:bullseye-slim as build

ARG CoreType

# Make directories, copy binary & scripts
RUN mkdir /home/moo-init
COPY ./restart.sh /usr/local/bin/restart

# Copy the latest selected core
COPY ./Cores/${CoreType}.db /home/moo/moo.db
RUN cp /home/moo/moo.db /home/moo-init/moo.db

# Copy our scripts to execute the moo
COPY ./startup.sh /usr/local/bin/startup
COPY ./restart.sh /usr/local/bin/restart
COPY ./buildParameters.sh /usr/local/bin/buildParameters

# Install the various dependent packages
RUN apt-get update && \
    apt-get install -y \
      bison \
      build-essential \
      git \
      gperf

# Pull the ToastStunt repo, checkout the server source for 2.7.0 r39
ADD https://api.github.com/repos/wrog/lambdamoo/compare/master...HEAD /dev/null
RUN git clone https://github.com/wrog/lambdamoo /src/lambdamoo
WORKDIR /src/lambdamoo
RUN git checkout b81bf9d

# Build the server and copy our binary to the bin directory
RUN sh configure
RUN make
RUN cp moo /usr/local/bin/moo

# Fix permissions on our various binaries and scripts just in case it is needed (but generally it will not be)
RUN chmod +x /usr/local/bin/moo && \
    chmod 777 /usr/local/bin/moo && \
    chmod +x /usr/local/bin/buildParameters && \
    chmod 777 /usr/local/bin/buildParameters && \
    chmod +x /usr/local/bin/restart && \
    chmod 777 /usr/local/bin/restart

FROM debian:bullseye-slim as final

ARG CoreType

LABEL  org.opencontainers.image.authors="Thaddeus Ryker <thad@edgerunner.org>"
LABEL version="1.8.3"
LABEL description="This is a version 1.8.3 Lambdamoo server packaged with a ${CoreType} core"
LABEL core="${CoreType}"

# build command: 
# docker build --build-arg CoreType="Lambdamoo" -f "v1.8.3/Dockerfile" -t wiredwizard/lambdamoo:1.8.3 .
# docker build --build-arg CoreType="Lambdamoo2018" -f "v1.8.3/Dockerfile" -t wiredwizard/lambdamoo:1.8.3-Lambdamoo2018 .
# docker build --build-arg CoreType="JH" -f "v1.8.3/Dockerfile" -t wiredwizard/lambdamoo:1.8.3-JHcore .
# docker build --build-arg CoreType="Minimal" -f "v1.8.3/Dockerfile" -t wiredwizard/lambdamoo:1.8.3-Minimal .

# Copy all our various files and directories now that all has been built
COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY --from=build /home/ /home/

# Install Tini for us to use to insure a graceful shutdown of the moo
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Install gosu to run at reduced permissions
RUN set -eux; \
    apt-get update; \
	apt-get install -y gosu; \
	rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
	gosu nobody true

# Set our default variables and expose our default port
ENV TZ="America/New_York"
ENV PORT="8888"
ENV INCLUDED_CORE=${CoreType}
EXPOSE ${PORT}/tcp

# Change our stop signal so that we can ensure a safe shutdown of the moo when the container stops
STOPSIGNAL SIGINT

# Create our moo user and group
RUN \
  groupadd -o --gid 10001 moo && \
  useradd -u 10000 -g moo -d /home/moo moo && \
  usermod -G users moo && \
  chown -R moo:moo /home/*

# Set directory to our moo and execute the restart script via Tini for clean process control
WORKDIR /home/moo
ENTRYPOINT ["/tini", "-g", "-v", "--", "startup", "moo"]
