#!/usr/bin/env bash

# To see the scripts that rpm runs: `rpm -q --scripts caddy`.

set -ex

bin_path='/usr/local/bin/caddy'
service_user_path='/service/caddy'

# Allow caddy to serve low-numbered ports.
sudo setcap cap_net_bind_service=+ep "$bin_path"

# Set SELinux context for caddy binary and service home directory.
sudo semanage fcontext --add --type httpd_exec_t "$bin_path"
sudo semanage fcontext --add --type httpd_config_t "$service_user_path/Caddyfile"
sudo semanage fcontext --add --type httpd_sys_content_t "$service_user_path/static/(/.*)?"
sudo restorecon -r "$bin_path" "$service_user_path"

# Allow caddy to serve QUIC.
sudo semanage port --add --type http_port_t --proto udp 80
sudo semanage port --add --type http_port_t --proto udp 443
