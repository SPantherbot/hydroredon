# Use a base image that supports systemd, for example, Ubuntu
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y shellinabox wget unzip && \
    apt-get install -y systemd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN echo 'root:root' | chpasswd

# Download and install ngrok
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip && \
    mv ngrok /usr/local/bin && \
    rm ngrok-stable-linux-amd64.zip

# Expose the web-based terminal port
EXPOSE 4200

# Start shellinabox and ngrok
CMD /usr/bin/shellinaboxd -t -s /:LOGIN & /usr/local/bin/ngrok http 4200 -authtoken=2Xj9GlTTttWVgopT1ZdsxzY1y3U_67YMfTo4zV1wNJ6VbHP7o
