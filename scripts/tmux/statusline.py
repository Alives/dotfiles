#!/usr/bin/env python
# -*- coding: utf-8 -*- 


import os
import signal
import socket
from subprocess import PIPE, Popen
from time import strftime, time


class Network():
  """Get network stats and return throughput rates.

  This class determines the statistics for all local network adapters other than
  lo and determines the rate since the last query. It then humanizes the output
  into b/s, KB/s, MB/s, or GB/s.
  """
  RX_ICON = '↓'
  TX_ICON = '↑'

  PREFIX = '#[fg=colour27,bg=colour0]#[fg=colour255,bg=colour27]'
  SUFFIX = '#[fg=colour0,bg=colour27]#[bg=colour0]'

  def __init__(self):
    self.os_type = os.uname()[0]
    self.prev_stats = {'rxbytes': 0, 'txbytes': 0, 'time': 0}
    self.curr_stats = {'rxbytes': 0, 'txbytes': 0, 'time': 0}
    self.rates = {'rx': {'rate': 0, 'units': ''},
                  'tx': {'rate': 0, 'units': ''}}
    self.Update()

  def GetNetBytes(self):
    """Get network statistics depending on platform.

    Sums the interface statistics for all interfaces other than lo and records
    the time they were captured.
    """
    self.curr_stats['rxbytes'] = 0
    self.curr_stats['txbytes'] = 0
    interfaces = []
    if self.os_type == 'Darwin':
      output = Popen(['netstat', '-nbi'], stdout=PIPE,
          shell=False).communicate()[0]
      self.curr_stats['time'] = time()
      for line in output.split('\n'):
        data = line.split()
        if len(data) < 10:
          continue
        if 'lo' in data[0] or 'Name' in data[0]:
          continue
        interface = data[0]
        if interface in interfaces:
          continue
        try:
          self.curr_stats['rxbytes'] += int(data[6])
          self.curr_stats['txbytes'] += int(data[9])
        except:
          continue
        interfaces.append(interface)

    elif self.os_type == 'Linux':
      proc_net_dev = open('/proc/net/dev')
      output = proc_net_dev.readlines()
      proc_net_dev.close()
      self.curr_stats['time'] = time()
      for line in output:
        data = line.split()
        if 'lo' in data or 'Inter-' in data or 'face' in data:
          continue
        interface = data[0]
        if interface in interfaces:
          continue
        try:
          self.curr_stats['rxbytes'] += int(data[1])
          self.curr_stats['txbytes'] += int(data[9])
        except:
          continue
        interfaces.append(interface)

    return

  def GetRates(self):
    """Determine the rate of change since the last collection."""
    delta_time = self.curr_stats['time'] - self.prev_stats['time']
    for key in ['rx', 'tx']:
      byte_key = '%sbytes' % key
      try:
        self.rates[key]['rate'] = (
            (self.curr_stats[byte_key] - self.prev_stats[byte_key]) / delta_time)
      except:
        self.rates[key]['rate'] = 0

  def GetUnits(self):
    """Convert to human readable units."""
    for key in ['rx', 'tx']:
      if self.rates[key]['rate'] >= 1073741824:
        self.rates[key]['units'] = 'GB/s'
        self.rates[key]['rate'] /= 1073741824
      elif self.rates[key]['rate'] >= 1048576:
        self.rates[key]['units'] = 'MB/s'
        self.rates[key]['rate'] /= 1048576
      elif self.rates[key]['rate'] >= 1024:
        self.rates[key]['units'] = 'KB/s'
        self.rates[key]['rate'] /= 1024
      else:
        self.rates[key]['units'] = 'b/s'

  def Update(self):
    """Update the stats and return them."""
    self.GetNetBytes()
    self.GetRates()
    self.GetUnits()
    for key in self.curr_stats:
      self.prev_stats[key] = self.curr_stats[key]
    status = ('%s %s%2.0f%s %s%2.0f%s %s' % (self.PREFIX,
        self.RX_ICON, self.rates['rx']['rate'], self.rates['rx']['units'],
        self.TX_ICON, self.rates['tx']['rate'], self.rates['tx']['units'],
        self.SUFFIX))
    return status


class Load():
  """Get the current load and return it for output."""
  PREFIX = '#[fg=colour34,bg=colour0]#[fg=colour255,bg=colour34]'
  SUFFIX = '#[fg=colour0,bg=colour34]'

  def Update(self):
    load = ' '.join(['%0.2f' % x for x in os.getloadavg()])
    status = '%s %s %s' % (self.PREFIX, load, self.SUFFIX)
    return status


class Clock():
  """Get the current time and return it for output."""
  PREFIX = '#[fg=colour220,bg=colour0]#[fg=colour0,bg=colour220]'
  SUFFIX = '#[default]'

  def Update(self):
    time_str = strftime('%l:%M:%S %p').lstrip()
    status = '%s %s %s' % (self.PREFIX, time_str, self.SUFFIX)
    return status


class StatusLine():
  """The main statusline class."""
  HOST = '127.0.0.1'
  PORT = 61234
  STATUSLINE_LOCK = '%s/.tmux.statusline.pid' % os.environ['HOME']
  TMUX_CONF = '%s/.tmux.conf' % os.environ['HOME']

  def __init__(self):
    self.GetLock()
    self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

  def CheckPid(self, pid):
    """Check if a pid is valid (running)."""
    try:
      os.kill(pid, 0)
    except:
      return False
    else:
      return True

  def UnLock(self):
    """Give up the lock."""
    os.unlink(self.STATUSLINE_LOCK)
    return

  def Lock(self):
    """Set the lock."""
    lock = open(self.STATUSLINE_LOCK, 'w')
    lock.write(str(os.getpid()))
    lock.close()

  def GetLock(self):
    """Simple process locking using a pid."""
    try:
      lock = open(self.STATUSLINE_LOCK)
      pid = lock.readline()
      lock.close()
    except:
      pid = None
    if not self.CheckPid(pid):
      self.Lock()
    else:
      exit(1)
    return

  def SigHandler(self, SIG, FRM):
    self.sock.close()
    self.UnLock()
    exit(0)

  def Run(self, modules):
    """Listen on self.PORT for a connection and update stats and return them."""
    self.sock.bind((self.HOST, self.PORT))
    self.sock.listen(3)
    while True:
      conn = self.sock.accept()[0]
      statusline = ''
      for module in modules:
        statusline += '%s' % module.Update()
      conn.send(statusline)
      conn.close()


if __name__ == "__main__":
  sl = StatusLine()

  # Setup the signal handler.
  for i in [x for x in dir(signal) if x.startswith("SIG")]:
    try:
      signum = getattr(signal, i)
      signal.signal(signum, sl.SigHandler)
    except:
      continue

  # Setup modules.
  network = Network()
  load = Load()
  clock = Clock()

  # List modules in the order they should appear in the statusline output.
  sl.Run([network, load, clock])
