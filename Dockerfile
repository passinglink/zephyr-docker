FROM ubuntu:20.04

RUN apt-get -y update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install --no-install-recommends build-essential cmake gcc-multilib g++-multilib git ninja-build python3-pip python3-setuptools python3-pyelftools wget
RUN pip3 install west

ARG ZEPHYR_SDK_VERSION=0.11.1
ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr
ENV ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk
ENV ZEPHYR_SDK_URL=https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run

RUN wget -q $ZEPHYR_SDK_URL && \
    yes n | sh zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run -- -d $ZEPHYR_SDK_INSTALL_DIR && \
    rm zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run

RUN west init /zephyr
RUN cd /zephyr && west update

# imgtool dependencies
RUN pip3 install click cryptography cbor intelhex

ADD fetch.sh /
RUN chmod 755 /fetch.sh
