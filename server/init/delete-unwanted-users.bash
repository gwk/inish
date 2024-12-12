#!/usr/bin/env bash

# Delete useless classic Unix users and groups.


set -e

unwanted_users=(
  'bin'
  'daemon'
  'lp'
  'sync'
  'shutdown'
  'halt'
  'games'
  'ftp'
)


unwanted_groups=(
  'bin'
  'daemon'
  'lp'
  'games'
  'ftp'
)


for user in "${unwanted_users[@]}"; do
  id -u "$user" || continue
  echo "Deleting user: $user"
  userdel --selinux-user "$user"
done

for group in "${unwanted_groups[@]}"; do
  getent group "$group" || continue
  echo "Deleting group: $group"
  groupdel "$group"
done
