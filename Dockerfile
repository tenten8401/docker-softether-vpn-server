FROM alpine:3.6
LABEL maintainer="Isaac A. <isaac@isaacs.site>" \
      contributor="Dimitri G. <dev@dmgnx.net>" \
      contributor="Antoine Mary <antoinee.mary@gmail.com>"

### SET ENVIRONNEMENT
ENV LANG="en_US.UTF-8" \

### SETUP
COPY assets /assets
RUN set -ex ; \
    addgroup -S softether ; adduser -D -H softether -g softether -G softether -s /sbin/nologin ; \
    apk add --no-cache --virtual .build-deps gcc make musl-dev ncurses-dev openssl-dev readline-dev wget ; \
    mv /assets/entrypoint.sh / ; chmod +x /entrypoint.sh ; \

    # Fetch sources
    git clone https://github.com/SoftEtherVPN/SoftEtherVPN_Stable
    cd SoftEtherVPN_Stable ; \
    # Patching sources
    for file in /assets/patchs/*.sh; do /bin/sh "$file"; done ; \
    # Compile and Install
    cp src/makefiles/linux_64bit.mak Makefile ; \
    make ; make install ; make clean ; \
    # Stripping vpnserver
    strip /usr/vpnserver/vpnserver ; \
    mkdir -p /etc/vpnserver /var/log/vpnserver; ln -s /etc/vpnserver/vpn_server.config /usr/vpnserver/vpn_server.config ; \

    # Cleaning
    apk del .build-deps ; \
    # Reintroduce necessary libraries
    apk add --no-cache --virtual .run-deps \
      libcap libcrypto1.0 libssl1.0 ncurses-libs readline su-exec ; \
    # Remove vpnbridge, vpnclient, vpncmd, and build files
    cd .. ; rm -rf /usr/vpnbridge /usr/bin/vpnbridge /usr/vpnclient /usr/bin/vpnclient /usr/vpncmd /usr/bin/vpncmd /usr/bin/vpnserver /assets SoftEtherVPN-${SOFTETHER_VERSION:1} ;

EXPOSE 443/tcp 992/tcp 1194/udp 5555/tcp

VOLUME ["/etc/vpnserver", "/var/log/vpnserver"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/vpnserver/vpnserver", "execsvc"]
