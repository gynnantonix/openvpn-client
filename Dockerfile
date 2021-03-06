FROM alpine

# Install openvpn
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl ip6tables iptables openvpn \
                shadow tini tzdata && \
    addgroup -S vpn && \
    rm -rf /tmp/*

COPY openvpn.sh /usr/bin/
COPY configs /vpn

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
             CMD curl -LSs 'https://api.ipify.org'

ENTRYPOINT ["/sbin/tini", "--", "/vpn/start.sh"]