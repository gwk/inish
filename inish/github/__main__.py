# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

from pithy.argparse import CommandParser

from . import download_release


def main() -> None:
   parser = CommandParser()

   downlead_release_cmd = parser.add_command(download_release)
   downlead_release_cmd.add_argument('repo', type=str)
   downlead_release_cmd.add_argument('-name', type=str, default='.+')
   downlead_release_cmd.add_argument('-assets', nargs='+', type=str, required=True)

   parser.parse_and_run_command()


if __name__ == '__main__': main()
