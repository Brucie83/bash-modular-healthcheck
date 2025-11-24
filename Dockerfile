FROM alpine:3.19

RUN apk add --no-cache bash curl util-linux procps netcat-openbsd
WORKDIR /opt/healthcheck
COPY healthcheck.config .
COPY healthcheck.sh .
COPY healthcheck.d ./healthcheck.d

RUN chmod +x healthcheck.sh
ENTRYPOINT ["./healthcheck.sh"]

CMD []
