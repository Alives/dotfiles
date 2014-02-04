#!/usr/bin/env python

import socket
from os.path import expanduser
from signal import signal, SIGINT
from sys import argv, stdout
from time import sleep


def SignalHandler(signal, frame):
  exit(130)


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
    conn = socket.create_connection((hostname, port), 1)
    response = conn.recv(1024)
  except:
    return False
  conn.close()
  if 'SSH' in response:
    return True
  return False


def main():
  signal(SIGINT, SignalHandler)
  count = 0
  spinner = '-\\|/'
  dest = argv[1]
  if 'server' in dest:
    exit(131)
  if 'sizzurp' in dest:
    if TestConnectivity(('localhost', 2223)):
        exit(132)
  if 'ssh-a' in dest:
    if TestConnectivity(('localhost', 2224)):
        exit(133)
  localhost = ParseSSHConfig('localhost')
  target = ParseSSHConfig(dest)
  while True:
    for host in [target, localhost]:
      if TestConnectivity(host):
        if host[1] == target[1]:
          exit(131)
        elif host[1] == localhost[1]:
          exit(132)
    stdout.write('\x1b[0m\r%c\x1b[30m' % (spinner[count % 4]))
    stdout.flush()
    count += 1
    sleep(0.5)


if __name__ == '__main__':
  main()
