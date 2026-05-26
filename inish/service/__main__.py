# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

from argparse import Namespace

from pithy.argparser import CommandParser

from .activate import activate_service
from .construct import construct_service


def main() -> None:
  parser = CommandParser()

  construct_cmd =parser.add_command(main_construct, description='Construct a service deployment directory.')
  construct_cmd.add_argument('service')
  construct_cmd.add_argument('-user')
  construct_cmd.add_argument('-inish_file')

  activate_cmd = parser.add_command(main_activate, description='Activate a service deployment directory.')
  activate_cmd.add_argument('service')
  construct_cmd.add_argument('-user')
  construct_cmd.add_argument('-inish_file')

  parser.parse_and_run_command()


def main_construct(args:Namespace) -> None:
  construct_service(args.service, user=args.user, inish_file_path=args.inish_file)


def main_activate(args:Namespace) -> None:
  activate_service(args.service, user=args.user, inish_file_path=args.inish_file)


if __name__ == '__main__': main()
