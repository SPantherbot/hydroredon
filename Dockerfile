# Use a base image that supports systemd, for example, Ubuntu
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y openssh-server wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Allow root login and set password
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Download ngrok FreeBSD+.TGZ file
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-freebsd-amd64.tgz -O /ngrok.tgz

# Extract and install ngrok from the TGZ file
RUN tar -xzf /ngrok.tgz && \
    mv /ngrok /usr/local/bin/ngrok && \
    rm /ngrok.tgz

# Expose the SSH port
EXPOSE 22

# Start sshd and ngrok
CMD service ssh start && sleep 5 && /usr/local/bin/ngrok tcp 22 -authtoken=${NGROK_TOKEN}
