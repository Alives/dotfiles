#!/usr/bin/env python
# Author: elliott.friedman@gmail.com (Elliott Friedman)

import logging
import os
import re
import time
import urllib2

# Browse to the page that has the wallpaper resolution you want and modify the
# line below to match that (eg: modify date, widescreen, 2880x1800, etc):
INDEX = '/wallpaper/downloads/date/widescreen/2880x1800'

# Path to download to
DIR = '/Users/friedman/Pictures/Retina Wallpapers'

URL = 'http://interfacelift.com'
INDEX = '%s%s' % (URL, INDEX)
UA = ('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 '
      '(KHTML, like Gecko) Chrome/24.0.1312.52 Safari/537.17')
RE = '<a href="(/wallpaper/.*_%s\.jpg)"><img src="' % INDEX.split('/')[-1]

logging.basicConfig(
    format=('%(asctime)-18s.%(msecs)d %(filename)s:%(lineno)s]'
            '  %(message)s'), level=logging.DEBUG, datefmt='%m-%d %H:%M:%S')

count = 1
downloads = 0

def Finished():
  logging.info('Directory updated.  Downloaded %d wallpapers.', downloads)
  exit()

while True:
  headers = { 'User-Agent': UA }
  request = urllib2.Request('%s/index%d.html' % (INDEX, count), None, headers)
  data = urllib2.urlopen(request).read()
  pictures = re.findall(RE, data)
  for pic in pictures:
    filename = pic.split('/')[-1]
    if os.path.exists('%s/%s' % (DIR, filename)):
      logging.error('%s/%s exists, exiting.', DIR, filename)
      Finished()
    request = urllib2.Request('%s%s' % (URL, pic), None, headers)
    data = urllib2.urlopen(request).read()
    logging.info('Downloading %s%s...', URL, pic)
    pic_file = open('%s/%s' % (DIR, filename), 'w')
    pic_file.write(data)
    pic_file.close()
    downloads += 1
    time.sleep(1)
  if len(pictures) == 0:
    Finished()
  time.sleep(5)
  count += 1
