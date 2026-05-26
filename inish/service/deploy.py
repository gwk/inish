# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

'''
A deploy directory is named "d{N}" where N is a positive number.
'''

import re

from pithy.filestatus import is_dir
from pithy.fs import list_dir
from pithy.sectsyn import parse_sections
from tolkien import Source


deploy_name_re = re.compile(r'd(\d+)')


def is_deploy_dir(service_dir:str, name:str) -> bool:
  path = f'{service_dir}/{name}'
  return bool(is_dir(path, follow=False) and deploy_name_re.fullmatch(name))


def deploy_number(name:str) -> int:
  if m := deploy_name_re.fullmatch(name):
    return int(m.group(1))
  return 0


def calc_latest_deploy(service_dir:str) -> int:
  file_names = [n for n in list_dir(service_dir) if is_deploy_dir(service_dir, n)]
  return max(deploy_number(n) for n in file_names)


def parse_inish_text(name:str, text:str) -> dict[str,object]:
  doc = {}
  src = Source(name=name, text=text)
  for section in parse_sections(src, symbol='§', numbered=False, raises=True):
    if section.level != 0: src.fail((section, 'Nested sections are not allowed.'))
    title = src[section.title]
    body = src[section.body]
    doc[title] = body
  return doc
