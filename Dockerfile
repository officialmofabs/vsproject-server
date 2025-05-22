FROM ubuntu:latest

# Update and install desktop environment and XRDP
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y lubuntu-desktop && \
    apt install -y xrdp && \
    adduser xrdp ssl-cert

# Create a user and add to sudo group
RUN useradd -m vpcuser && \
    echo "vpcuser:1234" | chpasswd && \
    usermod -aG sudo vpcuser

# Expose port 3389
EXPOSE 3389

# Start services

CMD service xrdp start && \
    /bin/bash