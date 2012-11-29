Python online regex tester for Python 2.7+
==========================================

This is a full featured web based Python_ regexp tester wih:

- all main `re` methods: `re.search`, `re.match`, `re.findall`, `re.sub`, `re.subn`
- all main regex flags (`re.U`, `re.I`, `re.X`, etc)
- ajax powered live matching as you type the pattern
- match coloration

Try the demo_.

Setup
======

The clean way::

     pip install regextester
     regex_tester

Voilà. This should open a browser with the regex tester web page.

It works as a stand alone app as well::

     git clone git://github.com/ksamuel/Python-regex-tester.git regextester
     cd regextester/regex_tester; python regexp_tester.py


Dependancies
===================================

None

It uses:

- the Bottle_ Python micro framework
- the `Blueprint CSS`_ framework
- the jQuery_ javascript framework

But all of them are already provided, the whole thing being less than 500 ko.

There is even a stand alone one file version in the static folder. Although it's not the exact same version (the regex is not executed in separate process), it has the same features.

Since the project was initially only for us to use, it's taking advantages of a few advanced CSS selectors and some HTML 5 goodies. Make sure you have an up to date browser.

What it lacks
=============

- some love: design is not the strong point of the product. And a spiner for ajax requests would help.
- some configuration options: it dont haz it
- some use: I have no time to find bugs or write tests, so please use and report. I only use it in Firefox and Chrome on Ubuntu 11.10 when programming.
- some protection: you can make it crash if you enter huge chunks of text or a pattern with agressive lookaheads

I do accept pull requests :-)

Licence
===========

GPL2.

Honestly, only because that's the first FOSS licence I could find a text copy of when googling.


.. _Python: http://www.python.org/
.. _Bottle: http://bottlepy.org
.. _JQuery: http://jquery.com/
.. _Blueprint CSS: http://blueprintcss.org/
.. _demo: http://ksamuel.pythonanywhere.com/