#!/bin/bash

# http and ip.addr in {34.236.82.201}
# tls and ip.addr in {104.19.192.174}

npx wrangler d1 create truepass-db5 --location apac

mkdir -p usr/share/ssl/root
cp ~/.mitmproxy/mitmproxy-ca.pem usr/share/ssl/root/mitmproxy-ca.pem
zip /bin/redbean.com usr/share/ssl/root/mitmproxy-ca.pem
unzip -l /bin/redbean.com | grep mitmproxy-ca.pem

sudo cp mitmproxy-ca-cert.pem /usr/local/share/ca-certificates/mitmproxy.crt
sudo update-ca-certificates

# redbean
export no_proxy=localhost,127.0.0.1
export https_proxy=http://172.31.11.148:8888
export NODE_EXTRA_CA_CERTS=/usr/local/share/ca-certificates/mitmproxy.crt
export node_extra_ca_certs=/usr/local/share/ca-certificates/mitmproxy.crt
sudo iptables --table nat --append OUTPUT --protocol tcp --dport 443 --jump DNAT --to-destination 172.31.11.148:8888

# mitmproxy
sudo sysctl -w net.ipv4.ip_forward=1

export MITMPROXY_SSLKEYLOGFILE="$HOME/mitmproxy_sslkeys.log"

mitmproxy \
  --listen-host '172.31.11.148' \
  --listen-port 8888 \
  --mode 'regular' \
  --save-stream-file mitmproxy.log \
  --showhost \
  --ssl-insecure \
  --verbose

mitmproxy \
  --listen-host '0.0.0.0' \
  --listen-port 8888 \
  --mode 'transparent' \
  --save-stream-file mitmproxy.log

mitmweb \
  --listen-host 127.0.0.1 \
  --listen-port 8888 \
  --mode regular \
  --verbose

mitmproxy \
  --http2 \
  --listen-host 127.0.0.1 \
  --listen-port 8888 \
  --mode transparent \
  --verbose

mitmproxy \
  --allow-hosts '^httpbin\.org$' \
  --http2 \
  --listen-host 127.0.0.1 \
  --listen-port 8888 \
  --mode regular \
  --verbose

mitmproxy \
  --allow-hosts '^httpbin\.org$' \
  --certs '' \
  --http2 \
  --listen-host 127.0.0.1 \
  --listen-port 8888 \
  --mode regular \
  --verbose

curl \
  --verbose \
  --silent \
  --location \
  --retry 3 \
  --retry-delay 69 \
  --proxy http://127.0.0.1:8888 \
  --request GET \
  --url https://httpbin.org/get

curl \
  --verbose \
  --silent \
  --location \
  --retry 2 \
  --retry-delay 69 \
  --request GET \
  --url https://httpbin.org/get

# list all rules from the `filter` table
# --table: `filter`, `nat`, `mangle`, `raw`
sudo iptables --table filter --verbose --list --numeric --line-numbers

# flush all rules from the `filter` table
# --table: `filter`, `nat`, `mangle`, `raw`
sudo iptables --table filter --flush

# flush FORWARD rules from the `filter` table
# --table: `filter`, `nat`, `mangle`, `raw`
sudo iptables --table filter --flush FORWARD
