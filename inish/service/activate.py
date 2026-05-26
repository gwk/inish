# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

from os import symlink

from .deploy import calc_latest_deploy


def activate_service(service:str, user:str|None, inish_file_path:str|None) -> None:
  #currrent_deploy = calc_latest_deploy(service)

  if user is None: user = service

  deploy_num = calc_latest_deploy(service)
  deploy_dir = f'/service/{service}/d{deploy_num}'
  link = f'/service/{service}/current'
  symlink(deploy_dir, link)
