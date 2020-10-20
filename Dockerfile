FROM debian:buster-slim

# Install System Programs
RUN apt-get update && apt-get --no-install-recommends -y install \
    # Add core programs \
    supervisor syslog-ng ca-certificates coreutils expect wget snmp snmptrapd \
    # Uncomment the line below for Debugging Tools \
    # iproute2 net-tools nmap curl wget dnsutils htop vim procps \
    && apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

# Install tini
RUN cd /tmp && \
    wget -O tini https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-amd64 && \
    chmod 755 tini && \
    mv tini /sbin/tini

# Install filebeat
RUN cd /tmp && \
    wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.9.1-linux-x86_64.tar.gz && \
    tar xzvf filebeat-* && \
    cp filebeat-*/filebeat /usr/local/bin && \
    mkdir -p /etc/beat && \
    cp filebeat-*/filebeat.yml /etc/beat && \
    rm -rf /tmp/filebeat-*

SHELL ["/bin/bash", "-c"]

# Create a new user
WORKDIR /app
RUN set -euo pipefail && \
    addgroup --gid 1000 --system app && \
    adduser  --uid 1000 --system --ingroup app --home /app --no-create-home app
# TODO: Run as user app
# USER app

# All configs relevant to this Dockerfile are kept in /app
COPY supervisor.d /app/supervisor.d
COPY *.conf *.yml *.sh /app/
COPY conf /app/conf
RUN rmdir /etc/supervisor/conf.d && \
    ln -s /app/supervisor.d /etc/supervisor/conf.d && \
    chown -R 1000:1000 -R /app /var/log

# Enable HTTP API
RUN echo "[inet_http_server]" >> /etc/supervisor/supervisord.conf && \
    echo "port = localhost:9001" >> /etc/supervisor/supervisord.conf

COPY snmp.conf /etc/snmp/snmp.conf

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/app/entrypoint.sh"]
