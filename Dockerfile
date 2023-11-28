FROM ubuntu:latest

RUN apt-get update -y > /dev/null 2>&1 && \
    apt-get upgrade -y > /dev/null 2>&1 && \
    apt-get install -y locales ssh wget unzip -y > /dev/null 2>&1 && \
    locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8

# Consider using ARGs in the build command rather than as ENVs if security is a concern
# ARG NGROK_TOKEN
# ENV NGROK_TOKEN=${NGROK_TOKEN}

# NGROK_TOKEN should be passed as a build argument (--build-arg NGROK_TOKEN=your_token)
ARG NGROK_TOKEN
RUN wget -O /ngrok.zip https://bin.equinox.io/c/your-ngrok-token/ngrok-stable-linux-amd64.zip > /dev/null 2>&1 && \
    unzip /ngrok.zip -d /usr/local/bin > /dev/null 2>&1 && \
    echo "/usr/local/bin/ngrok authtoken ${NGROK_TOKEN}" >> /kaal.sh && \
    echo "/usr/local/bin/ngrok tcp 22 &>/dev/null &" >> /kaal.sh

RUN mkdir /run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo root:kaal | chpasswd && \
    service ssh start

RUN chmod 755 /kaal.sh

EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

CMD ["/bin/bash", "/kaal.sh"]


EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

CMD ["/bin/bash", "/kaal.sh"]
