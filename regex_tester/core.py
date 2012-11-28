#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: ai ts=4 sts=4 et sw=4 nu

# Note that while the regex tester test Python 2.7 regex idioms,
# the code base itself has been made to be run on host with Python 2.6

import re
import sys
import os
import webbrowser
import json

from pprint import pformat
from operator import or_

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
RUN_REGEX_SCRIPT = os.path.join(ROOT_DIR, 'run_regex.py')

try:
    import bottle
    import regex_tester
    ROOT_DIR = os.path.dirname(os.path.abspath(regex_tester.__file__))
    bottle.TEMPLATE_PATH.insert(0, os.path.join(ROOT_DIR, 'views'))
except ImportError:
    sys.path.insert(0, os.path.join(ROOT_DIR, 'libs'))
    import bottle

STATIC_FILES_ROOT = os.path.join(ROOT_DIR, 'static')

import envoy

from clize import clize
from bottle import get, post, request, route, run, view, static_file

DEBUG = False
TIMEOUT = 5
STATIC_FILES_ROOT = os.path.join(ROOT_DIR, 'static')
ENCODING = sys.stdout.encoding or 'utf-8'

RUN_REGEX_SCRIPT_PARAMS = (u' --function="%(function)s" --replace="%(replace)s"'
                           u' --isunicode="%(is_unicode)s"'
                           u' --flags="%(flags)s" -- "%(regex)s" ')

CODES = {
    'search': """re.search(%(is_unicode)s%(is_raw)s'''%(regex)s''', %(is_unicode)s'''%(text)s'''%(flags_param)s)""",
    'split': """re.split(%(is_unicode)s%(is_raw)s'''%(regex)s''', %(is_unicode)s'''%(text)s'''%(flags_param)s)""",
    'findall': """re.findall(%(is_unicode)s%(is_raw)s'''%(regex)s''', %(is_unicode)s'''%(text)s'''%(flags_param)s)""",
    'match': """re.match(%(is_unicode)s%(is_raw)s'''%(regex)s''', %(is_unicode)s'''%(text)s'''%(flags_param)s)""",
    'sub': """re.sub(%(is_unicode)s%(is_raw)s'''%(regex)s''', %(is_unicode)s%(is_raw)s'''%(replace)s''', %(is_unicode)s'''%(text)s'''%(flags_param)s)""",
    'subn': """re.subn(%(is_unicode)s%(is_raw)s'''%(regex)s''', %(is_unicode)s%(is_raw)s'''%(replace)s''', %(is_unicode)s'''%(text)s'''%(flags_param)s)""",
}

FLAGS = dict((flag, getattr(re, flag)) for flag in (
    'IGNORECASE',
    'LOCALE',
    'MULTILINE',
    'DOTALL',
    'UNICODE',
    'VERBOSE'
))

DEFAULT = {
        'regex': '',
        'text': '',
        'replace': '',
        'is_unicode': '',
        'error': '',
        'code': '',
        'result': None,
        'function': 'search',
        'is_unicode': 'u',
        'is_raw': 'r',
        'markers': '[]',
        'flags_param': '',
        'group': (),
        'groupdict': {}
    }


def regex(regex, function='search', replace='', isunicode='', flags='0', text=None):
    """
        Apply regex on text and return the results as a dictionary
    """

    text = text or sys.stdin.read()

    if isunicode:
        text = text.decode(ENCODING)
        regex = regex.decode(ENCODING)
        replace = regex.decode(ENCODING)

    pattern = re.compile(regex, flags=int(flags))

    try:
        if 'sub' in function:
            result = getattr(re, function)(pattern, replace, text)
        else:
            result = getattr(re, function)(pattern, text)
    except re.error as e:
        if text:
            raise e
        sys.exit(u'Error in your regular expression: %s' % e)

    out = {}

    if result:
        if hasattr(result, 'group'):
            out['group'] = pformat(result.group())
            out['groupdict'] = pformat(result.groupdict())
            markers = result.span()
        else:
            markers = (m.span() for m in re.finditer(regex, text, flags=flags))
            markers = (x for boundaries in markers for x in boundaries)

        out['markers'] = json.dumps(tuple(markers))

    return out



# todo: allow arguments functions surch as maxsplit for split

@get('/')
@view('index')
def index():
    ctx = dict(DEFAULT)
    ctx.update(dict((flag, False) for flag in FLAGS))
    return ctx


@post('/')
@view('index')
def index():

    forms = request.forms
    ctx = dict(DEFAULT)
    regex = forms.get('regex', '').decode('utf-8')
    text = forms.get('text', '').decode('utf-8')
    replace = forms.get('replace', '')
    is_unicode =  'u' * bool(forms.get('is_unicode', False))
    is_raw =  'r' * bool(forms.get('is_raw', False))
    function = forms.get('function', 'search')

    set_flags = dict((flag, bool(forms.get(flag))) for flag in FLAGS)
    ctx.update(set_flags)
    set_flags = set_flags.items()
    flags = reduce(or_, (FLAGS[flag] for flag, on in set_flags if on), 0)

    if function not in CODES:
        error = u'This function is not supported'

    ctx.update(locals())

    if regex.strip() and text.strip():

        if "'''" in regex:
            ctx['error'] = u"""
                        Regex containing ''' (triple single quotes) are
                        not supported
                            """
            return ctx

        if not is_raw:
            regex = regex.decode('unicode_escape')

        elif regex.endswith('\\'):
            ctx['error'] = u"""
                        Raw string litterals ending with '\\' are not supported
                        in Python
                           """
            return ctx

        params = RUN_REGEX_SCRIPT_PARAMS % ctx
        command = (u"python %s %s" % (RUN_REGEX_SCRIPT, params)).encode(ENCODING)
        r = envoy.run(command, data=text.encode(ENCODING), timeout=TIMEOUT)

        if r.status_code == -15:
            ctx['error'] = u"""
                                This regex took too much time to process. If
                                you want to experiment with heavy regexes,
                                download the stand alone version of the regex
                                tester, set the timeout to None and run it
                                on your machine.
                            """
        elif r.std_err:
           ctx['error'] =  r.std_err
        else:
            ctx.update(json.loads(r.std_out))

        if flags != 0:
            ctx['flags_param'] = ", flags=" + '|'.join('re.' + flag for flag, on in set_flags if on)
        ctx['code'] = CODES[function] % ctx

    return ctx


@route('/static/<filename>')
def server_static(filename):
    return static_file(filename, root=STATIC_FILES_ROOT)


@route('/download/<filename:path>')
def download(filename):
    return static_file(filename, root=STATIC_FILES_ROOT, download=filename)


@clize
def main(host='localhost', port=9999, debug=DEBUG):
    if debug:
        bottle.debug(True)
        run(host=host, port=port, reloader=True)
    else:
        webbrowser.open('http://%s:%s/' % (host, port))
        run(host=host, port=port)


if __name__ == "__main__":

    main(*sys.argv)