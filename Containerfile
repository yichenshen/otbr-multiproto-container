# Silabs components are readily packaged for debian and requires bookworm deps
FROM debian:bookworm-slim

# Setup installation and DOCKER env
ENV DEBIAN_FRONTEND=noninteractive
ENV DOCKER=1

# Silabs dhcp backports
# https://docs.silabs.com/openthread/latest/multiprotocol-solution-linux/running-multiprotocol-with-packages
RUN echo "deb http://deb.debian.org/debian bookworm-backports main" > /etc/apt/sources.list.d/bookworm-backports.list && \
    printf "Package: dhcpcd\nPin: release n=bookworm-backports\nPin-Priority: 1001\n\nPackage: dhcpcd-base\nPin: release n=bookworm-backports\nPin-Priority: 1001\n" > /etc/apt/preferences.d/bookworm-backports

# Update packages
RUN apt-get update

# Dependencies for setup
RUN apt-get install -y \
    lsb-release \
    wget \
    unzip \
    make

# Download Silabs packages
WORKDIR /tmp/silabs
RUN wget https://github.com/SiliconLabs/simplicity_sdk/releases/latest/download/debian-bookworm.zip
RUN unzip debian-bookworm.zip -d multiprotocol-packages

# Setup directories needed for ot-br setup
RUN mkdir -p /etc/iproute2 /etc/sysctl.d/

# Install cpcd and ot-br
RUN ARCH=$(dpkg --print-architecture) && \
    echo "Detected architecture: $ARCH" && \
    apt-get install -y \
    ./multiprotocol-packages/debian-bookworm/deb/libcpc3_*_${ARCH}.deb \
    ./multiprotocol-packages/debian-bookworm/deb/libcpc-dev_*_${ARCH}.deb \
    ./multiprotocol-packages/debian-bookworm/deb/cpcd_*_${ARCH}.deb \
    ./multiprotocol-packages/debian-bookworm/deb/ot-br-posix_*_${ARCH}.deb

# Start from root homedir
WORKDIR /root

# Cleanup
RUN apt-get remove -y \
    lsb-release \
    wget \
    unzip \
    make
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/silabs

CMD ["/bin/bash"]
