FROM alpine:3.14

RUN apk add --no-cache \
    bash \
    privoxy \
    openvpn \
    curl \
    coreutils \
    linux-tools \
    util-linux && \
    rename .new '' /etc/privoxy/*new

COPY start.sh /bin/

EXPOSE 8118

CMD [ "start.sh" ]