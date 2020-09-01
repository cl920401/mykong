FROM openresty:centos
LABEL maintainer="mini-gateway"

ENV KONG_VERSION 1.2.1

COPY ./kong  /kong
COPY ./kong.sh /kong.sh
COPY ./kong.conf /kong.conf
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./custom-plugins /custom-plugins

RUN useradd --uid 1337 kong && pushd /kong && make install && popd && chmod +x /kong.sh && ln -s  /kong.sh /usr/bin/kong

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000 8443 8001 8444

STOPSIGNAL SIGTERM

ENV KONG_PREFIX=/usr/local/kong
ENV KONG_DATABASE=postgres
ENV KONG_PG_HOST=127.0.0.1
ENV KONG_PG_PORT=5432
ENV KONG_PG_USER=kong
ENV KONG_PG_PASSWORD=kong
ENV KONG_PG_DATABASE=kong
ENV KONG_PROXY_LISTEN='0.0.0.0:8000, 0.0.0.0:8443 ssl'
ENV KONG_ADMIN_LISTEN='0.0.0.0:8001, 0.0.0.0:8444 ssl'

CMD ["kong", "docker-start"]
