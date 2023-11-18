FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get install -y systemd && \
    apt-get install -y wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo 'root:your_password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "Port 22" >> /etc/ssh/sshd_config

RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
RUN unzip ngrok-stable-linux-amd64.zip
RUN mv ngrok /usr/local/bin/
RUN rm ngrok-stable-linux-amd64.zip

# Set ngrok token
ENV NGROK_TOKEN 2WFva7dfEIvALzlolb2dwOhE4kw_26EgtxJTZbbJVuSqnxzcZ

# Expose SSH port
EXPOSE 22

# Start SSH and ngrok
CMD service ssh start && ngrok authtoken $NGROK_TOKEN && ngrok tcp 22
