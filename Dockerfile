FROM ubuntu:24.04

WORKDIR /root

# Install gnupg first to use apt-key
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y gnupg && \
    apt-get clean

# Add debug symbols repository first
RUN echo "deb http://ddebs.ubuntu.com noble main restricted universe multiverse" > /etc/apt/sources.list.d/ddebs.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F2EDC64DC5AEE1F6B9C621F0C8CAB6595FDFF622

RUN apt-get update && \
    apt-get install -y clang libbfd-dev uthash-dev libelf-dev libcapstone-dev sudo \
    libreadline-dev libiberty-dev libgsl-dev build-essential git debootstrap \
    file cargo openssh-server gcc libbpf1 libtirpc-dev \
    libdwarf1 debuginfod elfutils curl checksec vlc apache2-bin

COPY ./testcases /root

RUN dpkg -i ./apps/*deb

RUN make prepare

RUN make

