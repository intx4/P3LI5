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
        python3.7-dev \
    && apt-get -y install python3-pip \
    && apt-get install -y pkg-config \
    && :
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8


RUN apt-get install net-tools
RUN apt-get install lsof


#install go
RUN apt-get install wget -y
RUN wget -c -q https://golang.org/dl/go1.19.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xvzf go1.19.3.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin:/venv/bin
ENV PYTHONPATH=$PYTHONPATH:/root/pyli5/src
ENV GOPATH=$HOME

COPY pir root/pir
COPY li/pyli5 /root/pyli5
RUN pip3 install -r /root/pyli5/requirements.txt
RUN cd /root/pir && go build && cd /

CMD /mnt/icf/icf_init.sh
