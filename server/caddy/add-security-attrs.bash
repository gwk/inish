#!/usr/bin/env bash

# Set up the necessary SELinux attributes for caddy to run as a systemd service.
# We use the existing httpd context for caddy, which is what the rpm package does.
# The difference is that we run as the caddy service user, from a dedicated directory.

# To see the scripts that rpm runs: `rpm -q --scripts caddy`.

set -euo pipefail
set -x

bin_path='/usr/local/bin/caddy'
service_user_path='/service/caddy'

# Allow caddy to serve low-numbered ports.
sudo setcap cap_net_bind_service=+ep "$bin_path"

sudo setsebool -P httpd_can_network_relay on

# Set SELinux context for caddy binary and service home directory.
sudo semanage fcontext --add --type httpd_exec_t "$bin_path"
sudo semanage fcontext --add --type httpd_config_t "$service_user_path/Caddyfile"
sudo semanage fcontext --add --type httpd_sys_content_t "$service_user_path/static/(/.*)?"

sudo semanage fcontext --add --type httpd_var_run_t "$service_user_path/run(/.\*)?"
#^ The admin socket and autosave.json are placed in a subdirectory with the correct context,
#^ because caddy creates them and therefore they inherits the context of the parent directory.

sudo restorecon -r "$bin_path" "$service_user_path"

# Allow caddy to serve QUIC.
sudo semanage port --add --type http_port_t --proto udp 80
sudo semanage port --add --type http_port_t --proto udp 443
