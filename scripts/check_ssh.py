#!/usr/bin/env python

import socket
from os.path import expanduser
from signal import signal, SIGINT
from sys import argv, stdout
from time import sleep


def SignalHandler(signal, frame):
  exit(69)


def ParseSSHConfig(target):
  host = None
  port = 22
  hostname = target
  home = expanduser("~")
  conf = '%s/.ssh/config' % home
  ssh_config = open(conf, 'r')
  for line in ssh_config:
    line = line.strip()
    if not host and 'Host ' in line:
      host = line.split('Host ')[-1]
    elif host and 'HostName ' in line:
      hostname = line.split('HostName ')[-1]
    elif host and 'Port ' in line:
      port = int(line.split('Port ')[-1])
    elif len(line) == 0:
      if ((host and hostname and port) and
            (host == target)):
        return (hostname, port)
      host = None
      hostname = target
      port = 22
  return (hostname, port)


def TestConnectivity((hostname, port)):
  try:
<<<<<<< HEAD
    conn = socket.create_connection((hostname, port), 1)
    response = conn.recv(1024)
  except:
    return False
  conn.close()
  if 'SSH' in response:
    return True
  return False
=======
    conn = socket.create_connection((hostname, port), 0.1)
    response = conn.recv(1024)
    conn.close()
    if 'SSH' in response:
      return True
  except:
    return False
>>>>>>> 16acb304dbf95b217ed30fe4ccb554bf05818e51


def main():
  signal(SIGINT, SignalHandler)
  count = 0
  spinner = '-\\|/'
  host = argv[1]
  localhost = ParseSSHConfig('localhost')
  target = ParseSSHConfig(host)
  while True:
    for host in [target, localhost]:
      if TestConnectivity(host):
        exit(0)
    stdout.write('\x1b[0m\r%c\x1b[30m' % (spinner[count % 4]))
    stdout.flush()
    count += 1
    sleep(0.5)


if __name__ == '__main__':
  main()
