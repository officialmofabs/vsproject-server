# Use the CentOS base image
FROM centos:7

# Install necessary packages
RUN yum -y update && \
    yum -y install systemd

# Create a mount point for the systemd socket
VOLUME [ "/sys/fs/cgroup" ]

# Set the default command to run systemd
CMD ["/usr/sbin/init"]
