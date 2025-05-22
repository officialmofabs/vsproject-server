FROM ghcr.io/officialmofabs/basedevcontainer:alpine

# FROM officialmofabs/basedevcontainer:alpine

# FROM officialmofabs/basedevcontainer:debian

# update apt
RUN apt update

# install httpie
RUN apt install -y httpie

# install flyway
WORKDIR /workspaces/devcontainer
RUN wget -qO- https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/10.17.1/flyway-commandline-10.17.1-linux-x64.tar.gz \
    | tar -xvz && sudo ln -s `pwd`/flyway-10.17.1/flyway /usr/local/bin
RUN chmod +x /usr/local/bin/flyway

WORKDIR ~/workspaces/devcontainer
ENTRYPOINT ["/bin/bash"]
