import os
import time
import sys
while True:
    _, cols = os.popen('stty size', 'r').read().split()
    cols = int(cols)
    prefix = '\r\033[7m  Nano + VIM = Vimao | NeoVim'
    suffix = ''
    output = prefix + ' '*(cols - (len(prefix)-5 + len(suffix))) + suffix
    sys.stdout.write(output)
    sys.stdout.flush()
    time.sleep(1)