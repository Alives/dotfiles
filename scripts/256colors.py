#!/usr/bin/env python
# Original Author of the perl script: Todd Larason <jtl@molehill.org>
# $XFree86: xc/programs/xterm/vttests/256colors2.pl,v 1.2 2002/03/26 01:46:43 dickey Exp $

import sys
RESET = "\x1b[0m"
LAYERS = {38: 'foreground', 48: 'background'}

# System colors
max = 16
for layer in LAYERS.keys():
  print "System colors (%s):" % LAYERS[layer]
  for color in xrange(0,max):
    sys.stdout.write("%s %2d %s " % ("\x1b[%d;5;%sm" % (layer, color), color, RESET))
    if color == (max - 1) or color == ((max / 2) - 1):
      print
  print

# Color cube 6x6x6
for layer in LAYERS.keys():
  print "Color cube 6x6x6 (%s):" % LAYERS[layer]
  for green in xrange(0,6):
    for red in xrange(0,6):
      for blue in xrange(0,6):
        color = 16 + (red * 36) + (green * 6) + blue
        sys.stdout.write("%s%3d%s " % ("\x1b[%d;5;%sm" % (layer, color), color, RESET))
      sys.stdout.write(" ")
    print
  print

# Grayscale ramp
for layer in LAYERS.keys():
  print "System colors (%s):" % LAYERS[layer]
  for color in xrange(232,256):
    sys.stdout.write("%s %2d %s " % ("\x1b[%d;5;%sm" % (layer, color), color, RESET))
  print "\n"
