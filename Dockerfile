FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y openssh-server wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Allow root login and set password
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose the SSH port
EXPOSE 22

# Start sshd
CMD /usr/sbin/sshd -D
