# Use a base image that supports systemd, for example, Ubuntu
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y openssh-server wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up SSH
RUN mkdir /var/run/sshd
RUN echo 'root:your_password_here' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 80

# Install Ngrok and configure it for SSH tunneling
RUN wget -O /ngrok.zip https://bin.equinox.io/c/your-ngrok-token/ngrok-stable-linux-amd64.zip && \
    unzip /ngrok.zip -d /usr/local/bin && \
    echo "authtoken 2WFva7dfEIvALzlolb2dwOhE4kw_26EgtxJTZbbJVuSqnxzcZ" >> /root/.ngrok2/ngrok.yml && \
    /usr/local/bin/ngrok tcp 22 &>/dev/null &

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
