# syntax = docker/dockerfile:1.0-experimental
# Big thanks and credit to the coder crew and https://github.com/coder/code-server

FROM registry.access.redhat.com/ubi9/ubi:${RHEL_VERSION:-latest}

LABEL maintainer="Tok - Tony Kay tony.g.kay@gmail.com"

COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN dnf install -y https://github.com/coder/code-server/releases/download/v4.4.0/code-server-4.4.0-arm64.rpm \
    sudo \ 
    && useradd devops \
    && echo "devops ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && chmod +x /usr/bin/entrypoint.sh \
    && dnf clean all \
    && rm -rf /var/cache/yum /root/.cache

# TODO Install Ansible tooling (ansible, no need for navigator?)
# TODO Install oc
# TODO Install kubectl
# TODO Install nice to ahve utilities - so terminal feels like "a VM", ping, dig, nslookup etc

USER devops
WORKDIR /home/devops

EXPOSE 8080

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["code-server", "--bind-addr", "0.0.0.0:8080"]
