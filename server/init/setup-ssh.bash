#!/usr/bin/env bash

# Change SSH port to 424 to reduce the volume of SSH probing.

set -euo pipefail
set -x

echo -e 'Port 424' | sudo tee -a /etc/ssh/sshd_config.d/91-custom-port.conf

sudo semanage port -a -t ssh_port_t -p tcp 424
sudo semanage port -l | grep ssh_port_t | grep 424
#^ Verify that 424 is present.

sudo sshd -t && sudo systemctl restart sshd
#^ Test and restart sshd.
