FROM ghcr.io/naiba/nezha-dashboard

EXPOSE 80

WORKDIR /dashboard

COPY entrypoint.sh /dashboard/

COPY sqlite.db /dashboard/data/

RUN apt-get update &&\
    apt-get -y install openssh-server wget iproute2 vim git cron unzip supervisor systemctl &&\
    wget -O nezha-agent.zip https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#").zip &&\
    unzip nezha-agent.zip -d /usr/local/bin &&\
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#").deb &&\
    dpkg -i cloudflared.deb &&\
    wget -O grpcwebproxy.tar.gz https://github.com/fscarmen/tools/releases/download/grpcwebproxy/grpcwebproxy_linux_$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#").tar.gz &&\
    tar xzvf grpcwebproxy.tar.gz -C /usr/local/bin &&\
    rm -f nezha-agent.zip grpcwebproxy.tar.gz cloudflared.deb &&\
    touch /dbfile &&\
    chmod +x entrypoint.sh &&\
    git config --global core.bigFileThreshold 1k &&\
    git config --global core.compression 0 &&\
    git config --global advice.detachedHead false &&\
    git config --global pack.threads 1 &&\
    git config --global pack.windowMemory 50m &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["./entrypoint.sh"]