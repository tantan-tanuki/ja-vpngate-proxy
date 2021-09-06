FROM ubuntu:20.04

RUN apt update -y && apt install -y openvpn curl privoxy

COPY start.sh /bin/

EXPOSE 8118

CMD [ "start.sh" ]