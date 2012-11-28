#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: ai ts=4 sts=4 et sw=4 nu

"""
    Run the regex in a external process and print the result as json
"""

from core import clize, sys, json, regex

try:
    print json.dumps(clize(regex)(*sys.argv))
except Exception as e:
    import traceback
    sys.stderr.write('%s' % sys.argv)
    traceback.print_exc(sys.stderr)
    sys.exit(1)