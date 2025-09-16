# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

r'''
TEST: pym inish.github download-release vectordotdev/vector -name 'v\d+\.\d+\.\d+' -assets 'x86_64-unknown-linux-gnu\.tar\.gz'
'''

import re
from hashlib import sha256
from typing import Iterable

import requests
from pithy.argparse import Namespace
from pithy.io import errL


def download_release(namespace:Namespace) -> None:
  repo:str = namespace.repo
  name_pattern:str = namespace.name
  url = f'https://api.github.com/repos/{repo}/releases'
  response = requests.get(url)
  response.raise_for_status()
  releases = response.json()

  release_info = find_release_info(releases, name_pattern)
  errL(f'name: {release_info["name"]}; tag_name: {release_info["tag_name"]}; html_url: {release_info['html_url']}')

  assets = list(find_assets(release_info['assets'], namespace.assets))
  for asset in assets:
    errL(f'  {asset["name"]}; {asset["content_type"]}; size: {asset["size"]}; digest: {asset["digest"]}')

  download_and_verify_assets(assets)


def find_release_info(releases_json:list[dict], name_pattern:str) -> dict:
  name_re = re.compile(name_pattern)
  for release in releases_json:
    if name_re.fullmatch(release['name']):
      return release
  raise ValueError(f'No release found with pattern {name_pattern!r}.')


def find_assets(assets_json:list[dict], asset_patterns:list[str]) -> Iterable[dict]:
  for asset_re in [re.compile(asset) for asset in asset_patterns]:
    found_count = 0
    for asset in assets_json:
      if asset_re.search(asset['name']):
        yield asset
        found_count += 1
    if found_count == 0:
      raise ValueError(f'No asset found with pattern {asset_re!r}.')
    if found_count > 1:
      raise ValueError(f'Multiple assets found with pattern {asset_re!r}.')


def download_and_verify_assets(assets:list[dict]) -> None:
  for asset in assets:
    download_and_verify_asset(asset)


def download_and_verify_asset(asset:dict) -> None:
  'Download an asset to disk and verify its digest.'
  url = asset['browser_download_url']

  exp_size = asset['size']

  exp_digest_str = asset['digest']
  if not exp_digest_str.startswith('sha256:'):
    raise ValueError(f'Expected digest to start with "sha256:"; actual: {exp_digest_str!r}.')

  exp_digest = exp_digest_str.removeprefix('sha256:')

  response = requests.get(url)
  response.raise_for_status()
  content = response.content

  if len(content) != exp_size:
    raise ValueError(f'Downloaded asset size does not match expected: {len(content)} != {exp_size}.')

  digest = sha256(content).hexdigest()
  if digest != exp_digest:
    raise ValueError(f'Downloaded asset digest does not match expected: {digest} != {exp_digest}.')

  name = asset['name']
  with open(name, 'wb') as f:
    f.write(response.content)
