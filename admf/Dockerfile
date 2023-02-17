FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

# Install updates and dependencies
RUN apt-get update && apt-get upgrade -y
# install python
RUN : \
    && apt-get install -y --no-install-recommends \
        software-properties-common \
    && add-apt-repository -y ppa:deadsnakes \
    && apt-get install -y --no-install-recommends \
        python3.8 \
    && apt-get -y install python3-pip \
    && :
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN cp -R /mnt/li/pyli5 /root/pyli5
RUN pip3 install -r /root/pyli5/requirements.txt
CMD /mnt/admf/admf_init.sh
