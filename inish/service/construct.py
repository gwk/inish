# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

from os import chown
from pwd import getpwnam

from pithy.fs import make_dir

from .deploy import calc_latest_deploy


def construct_service(service:str, user:str|None, inish_file_path:str) -> None:

  if user is None: user = service
  pw = getpwnam(user)
  uid = pw.pw_uid
  gid = pw.pw_gid

  last_deploy_num = calc_latest_deploy(service)
  deploy_num = last_deploy_num + 1
  deploy_dir = f'/service/{service}/d{deploy_num}'
  make_dir(deploy_dir)
  chown(deploy_dir, uid, gid)
  print(deploy_dir)
