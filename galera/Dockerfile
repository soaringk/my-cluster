FROM haproxy:2.2.2-alpine

RUN apk update \
    && apk add --no-cache bash curl ipvsadm iproute2 openrc keepalived mysql-client \
    && rm -f /var/cache/apk/* /tmp/*

COPY entrypoint.sh clustercheck /opt/
RUN chmod +x /opt/entrypoint.sh
RUN chmod +x /opt/clustercheck

CMD ["/opt/entrypoint.sh"]
