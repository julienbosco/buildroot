FROM debian:sid

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update -y
RUN apt-get install -y --no-install-recommends \
        bc \
        bison \
        build-essential \
        bzr \
        ca-certificates \
        cmake \
        cpio \
        curl \
        cvs \
        file \
        flex \
        g++-multilib \
        gcc-or1k-elf \
        git \
        libc6:i386 \
        libncurses5-dev \
        locales \
        mercurial \
        python3 \
        python3-dev \
        python3-flake8 \
        python3-nose2 \
        python3-pexpect \
        qemu-system-arm \
        qemu-system-x86 \
        rsync \
        subversion \
        unzip \
        vim \
        wget \
        && \
    apt-get -y autoremove && \
    apt-get -y clean

# To be able to generate a toolchain with locales, enable one UTF-8 locale
RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    /usr/sbin/locale-gen

RUN curl -LJO https://musl.cc/or1k-linux-musl-cross.tgz
RUN tar xf or1k-linux-musl-cross.tgz && cp -r or1k*/usr/* /usr

RUN useradd -ms /bin/bash br-user && \
    chown -R br-user:br-user /home/br-user

USER br-user
WORKDIR /home/br-user
ENV HOME /home/br-user
ENV BRDIR $HOME/buildroot
ENV LC_ALL en_US.UTF-8

RUN mkdir $HOME/.buildroot-ccache
VOLUME $HOME/.buildroot-ccache
RUN curl -O https://buildroot.org/downloads/buildroot-2021.08.2.tar.gz && tar -xf $HOME/buildroot-2021.08.2.tar.gz
RUN mv $HOME/buildroot-2021.08.2 $BRDIR
RUN rm buildroot-2021.08.2.tar.gz
RUN mkdir $BRDIR/dl
VOLUME $BRDIR/dl

RUN mkdir $BRDIR/output
RUN git clone https://github.com/crust-firmware/crust $BRDIR/output/crust

RUN mkdir $HOME/output
VOLUME $HOME/output

