FROM debian:stretch-slim

# Install System Programs
RUN apt-get update && apt-get --no-install-recommends -y install \
    # Add core programs \
    supervisor syslog-ng ca-certificates coreutils expect git snmp snmptrapd \
    # Add Debugging Tools (Removable in the future) \
    iproute2 net-tools nmap curl wget dnsutils && \
    apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

# Install tini
RUN cd /tmp && \
    wget -O tini https://github.com/krallin/tini/releases/download/v0.18.0/tini-static-amd64 && \
    chmod 755 tini && \
    mv tini /sbin/tini

# Install filebeat
RUN cd /tmp && \
    wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.0.0-linux-x86_64.tar.gz && \
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
COPY entrypoint.sh .
COPY supervisor.d ./supervisor.d
COPY app.sh .
COPY snmptrapd.conf .
COPY filebeat.yml .
RUN rmdir /etc/supervisor/conf.d && \
    ln -s /app/supervisor.d /etc/supervisor/conf.d && \
    chown -R 1000:1000 -R /app /var/log

COPY snmp.conf /etc/snmp/snmp.conf

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/app/entrypoint.sh"]
