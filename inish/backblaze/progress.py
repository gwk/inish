# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

from sys import stderr
from time import monotonic, time

from b2sdk.v3 import AbstractProgressListener


class ProgressListener(AbstractProgressListener):
  '''
  A progress listener which prints to TTY stderr.
  '''

  def __init__(self, description:str='Progress') -> None:
    self.description = description
    self.last_time = monotonic()
    self.total_bytes = 0
    super().__init__(description=description)

  def set_total_bytes(self, total_byte_count: int) -> None:
    self.total_bytes = total_byte_count

  def bytes_completed(self, byte_count: int) -> None:
      now = monotonic()
      elapsed = now - self.last_time
      if elapsed >= 0.1 and self.total_bytes:
        percent = 100.0 * byte_count / self.total_bytes
        print(f'\r{self.description}: {percent:.1f}%', end='', file=stderr, flush=True)
        self.last_time = now

  def close(self) -> None:
    print(f'\r{self.description}: 100.0%', file=stderr)
    super().close()
