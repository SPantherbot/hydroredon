# Use a base image that supports systemd, for example, Ubuntu
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y shellinabox wget unzip openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set root password (change 'rootpassword' to your desired password)
RUN echo 'root:rootpassword' | chpasswd

# Enable root login via SSH and allow password authentication
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Start SSH service
RUN service ssh start

# Download and install ngrok from .TGZ file
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xzf ngrok-v3-stable-linux-amd64.tgz && \
    mv ngrok /usr/local/bin && \
    rm ngrok-v3-stable-linux-amd64.tgz

# Expose the SSH port and web-based terminal port
EXPOSE 22 4200

# Start shellinabox and ngrok for web-based terminal access and SSH tunneling
CMD /usr/bin/shellinaboxd -t -s /:LOGIN & /usr/local/bin/ngrok tcp 22 --authtoken= 2WFva7dfEIvALzlolb2dwOhE4kw_26EgtxJTZbbJVuSqnxzcZ
