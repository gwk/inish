# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

from pithy.argparse import CommandParser


def main() -> None:
  parser = CommandParser(description='Server initialization.')
  args = parser.parse_args()
  exit('Not implemented.')


if __name__ == '__main__': main()
