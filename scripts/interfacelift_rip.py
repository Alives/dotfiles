#!/usr/bin/env python
# Author: elliott.friedman@gmail.com (Elliott Friedman)
#
# This script downloads interfacelift.com wallpapers.  It is intended to be run
# as a cron job to keep your local directory up to date.

# You will need to modify the next 2 variables:

# Browse to the page that has the wallpaper resolution you want and modify the
# line below to match that (eg: modify date, widescreen, 2880x1800, etc):
INDEX = '/wallpaper/downloads/date/widescreen/2880x1800'

# Path to download to (no escaping needed).
DIR = '/Users/friedman/Pictures/Retina Wallpapers'


# You do not need to modify anything below this line.
import logging
import os
import re
import time
import urllib2

URL = 'http://interfacelift.com'
INDEX = '%s%s' % (URL, INDEX)
UA = ('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 '
      '(KHTML, like Gecko) Chrome/24.0.1312.52 Safari/537.17')
RE = r'<a href="(/wallpaper/.*_%s\.jpg)"><img src="' % INDEX.split('/')[-1]
count = 1
downloads = 0
logging.basicConfig(
    format=('%(asctime)s.%(msecs)-3d %(filename)s:%(lineno)s]'
            '  %(message)s'), level=logging.DEBUG, datefmt='%m-%d %H:%M:%S')


def Finished():
  logging.info('Downloaded %d wallpapers.  Directory is now up to date.',
      downloads)
  exit()


while True:
  headers = {'User-Agent': UA}
  request = urllib2.Request('%s/index%d.html' % (INDEX, count), None, headers)
  data = urllib2.urlopen(request).read()
  logging.debug('Grabbed %s/index%d.html', INDEX, count)
  pictures = re.findall(RE, data)
  logging.debug('Found %d wallpaper files.', len(pictures))
  for pic in pictures:
    logging.debug('Working on %s', pic.split('/')[-1])
    filename = pic.split('/')[-1]
    if os.path.exists('%s/%s' % (DIR, filename)):
      logging.error('%s/%s exists, exiting.', DIR, filename)
      Finished()
    request = urllib2.Request('%s%s' % (URL, pic), None, headers)
    data = urllib2.urlopen(request).read()
    logging.debug('Downloading %s%s...', URL, pic)
    pic_file = open('%s/%s' % (DIR, filename), 'w')
    pic_file.write(data)
    pic_file.close()
    downloads += 1
    time.sleep(1)
  if not pictures:
    Finished()
  time.sleep(5)
  count += 1
