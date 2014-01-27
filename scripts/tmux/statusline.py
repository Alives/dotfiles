#!/usr/bin/env python
# -*- coding: utf-8 -*- 


import os
import subprocess
from time import sleep, time


STATUSLINE_FILE = '%s/.tmux.statusline.txt' % os.environ['HOME']
STATUSLINE_LOCK = '%s/.tmux.statusline.pid' % os.environ['HOME']
TMUX_CONF = '%s/.tmux.conf' % os.environ['HOME']


class Network():
  RX_ICON = '↓'
  TX_ICON = '↑'

  PREFIX = '#[fg=colour27,bg=colour0]#[fg=colour255,bg=colour27] '
  SUFFIX = ' #[fg=colour0,bg=colour27]#[bg=colour0]'

  def __init__(self):
    self.os_type = os.uname()[0]
    self.prev_stats = {'rxbytes': 0, 'txbytes': 0, 'time': 0}
    self.curr_stats = {'rxbytes': 0, 'txbytes': 0, 'time': 0}
    self.rates = {'rx': {'rate': 0, 'units': ''},
                  'tx': {'rate': 0, 'units': ''}}
    self.Update()

  def GetNetBytes(self):
    self.curr_stats['rxbytes'] = 0
    self.curr_stats['txbytes'] = 0
    interfaces = []
    if self.os_type == 'Darwin':
      output = subprocess.Popen(['netstat', '-nbi'], stdout=subprocess.PIPE,
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
          mtu = int(data[1])
          self.curr_stats['rxbytes'] += int(data[6])
          self.curr_stats['txbytes'] += int(data[9])
        except:
          continue
        interfaces.append(interface)
    elif OS_TYPE == 'Linux':
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
    delta_time = self.curr_stats['time'] - self.prev_stats['time']
    for i in ['rx', 'tx']:
      key = '%sbytes' % i
      try:
        self.rates[i]['rate'] = (
            (self.curr_stats[key] - self.prev_stats[key]) / delta_time)
      except:
        self.rates[i]['rate'] = 0

  def GetUnits(self):
    KB = 1024
    for i in ['rx', 'tx']:
      if self.rates[i]['rate'] >= 1073741824:
        self.rates[i]['units'] = 'GB/s'
        self.rates[i]['rate'] /= 1073741824
      elif self.rates[i]['rate'] >= 1048576:
        self.rates[i]['units'] = 'MB/s'
        self.rates[i]['rate'] /= 1048576
      elif self.rates[i]['rate'] >= 1024:
        self.rates[i]['units'] = 'KB/s'
        self.rates[i]['rate'] /= 1024
      else:
        self.rates[i]['units'] = 'b/s'

  def Update(self):
    self.GetNetBytes()
    self.GetRates()
    self.GetUnits()
    for key in self.curr_stats:
      self.prev_stats[key] = self.curr_stats[key]
    status = ('%s%s%2.0f%s %s%2.0f%s%s' % (self.PREFIX,
        self.RX_ICON, self.rates['rx']['rate'], self.rates['rx']['units'],
        self.TX_ICON, self.rates['tx']['rate'], self.rates['tx']['units'],
        self.SUFFIX))
    return status


class Load():
  PREFIX = '#[fg=colour34,bg=colour0]#[fg=colour255,bg=colour34] '
  SUFFIX = ' '
  #SUFFIX = ' #[fg=colour0,bg=colour34]'

  def Update(self):
    load = ' '.join(['%0.2f' % load for load in os.getloadavg()])
    status = '%s%s%s' % (self.PREFIX, load, self.SUFFIX)
    return status

def GetStatusDelay():
  delay = -1
  f = open(TMUX_CONF)
  for line in f.readlines():
    if 'status-interval' in line:
      delay = int(line.split(' ')[-1])
      f.close()
      break
  return delay

def GetLock():
  def CheckPid(pid):
    try:
      os.kill(pid, 0)
    except:
      return False
    else:
      return True

  try:
    lock = open(STATUSLINE_LOCK)
    pid = lock.readline()
    lock.close()
  except:
    pid = -1

  if not CheckPid(pid):
    lock = open(STATUSLINE_LOCK, 'w')
    lock.write(str(os.getpid()))
    lock.close()
  else:
    exit(1)
  return


GetLock()
delay = GetStatusDelay()
network = Network()
load = Load()

# To make sure updates to the statusline file happen before it is read.
sleep(delay / 4)

while True:
  status = open(STATUSLINE_FILE, 'w')
  status.write('%s%s' % (network.Update(), load.Update()))
  status.close()
  sleep(delay)