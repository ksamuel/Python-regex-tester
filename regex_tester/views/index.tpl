<html>
<head>
    <title>Python 2.7+ Regex Tester</title>

    <meta name="keywords"
          content="Python, regex, regexp, regular expression, tester, online, ajax" />
    <meta name="Description"
          content="A standalone Python 2.7 online regex tester using the Bottle framework" />

    <link rel="stylesheet" href="static/screen.css">
    <link rel="stylesheet" href="static/style.css">

</head>
<body>

<div class="container content">

<h1>Python 2.7+ Regex Tester</h1>

<form action="." method="post" accept-charset="utf-8">

<div id="regex">

    <p>
        <input type="radio" name="function"  value="search" id="search"
               %if function == 'search':
                   checked="checked"
               %end
             >
        <label for="search">re.search</label>

        <input type="radio" name="function" value="split" id="split"
               %if function == 'split':
                   checked="checked"
               %end
             >
        <label for="split">re.split</label>


        <input type="radio" name="function" value="findall" id="findall"
               %if function == 'findall':
                   checked="checked"
               %end
             >
        <label for="findall">re.findall</label>

        <input type="radio" name="function" value="match" id="match"
               %if function == 'match':
                   checked="checked"
               %end
             >
        <label for="match">re.match</label>

        <input type="radio" name="function" value="sub" id="sub"
               %if function == 'sub':
                   checked="checked"
               %end
             >
        <label for="sub">re.sub</label>

        <input type="radio" name="function" value="subn" id="subn"
               %if function == 'subn':
                   checked="checked"
               %end
             >
        <label for="subn">re.subn</label>
    </p>

    <p>
        <input type="checkbox" name="is_unicode" id="is_unicode"
               %if is_unicode:
                   checked="checked"
               %end
             >
        <label for="is_unicode">Unicode string</label>

        <input type="checkbox" name="is_raw" id="is_raw"
               %if is_raw:
                   checked="checked"
               %end
             >
        <label for="is_raw">Raw string</label>
    </p>

    <p>
        <label for="regex">Regex: </label>
        <input autocomplete="off" type="text" name="regex" value="{{ regex }}" >
    </p>

    <details id='flags'>

        <summary>Flags</summary>

        <dl>
            <dt>
                <input {{ 'checked="checked"' if IGNORECASE else '' }}
                       required placeholder='E.G: (\d+) years'
                       type="checkbox" name="IGNORECASE" id='IGNORECASE'>
                <label for="IGNORECASE">re.IGNORECASE, re.I</label>
            </dt>
            <dd>
                Perform case-insensitive matching; expressions like [A-Z] will match
                lowercase letters, too. This is not affected by the current locale.
            </dd>
            <dt>
                <input {{ 'checked="checked"' if LOCALE else '' }}
                       type="checkbox" name="LOCALE" id='LOCALE'>
                <label for="LOCALE">re.LOCALE, re.L</label>
            </dt>
            <dd>
                Make \w, \W, \b, \B, \s and \S
                dependent on the current locale.
                </dd>
            <dt>
                <input {{ 'checked="checked"' if MULTILINE else '' }}
                       type="checkbox" name="MULTILINE" id='MULTILINE'>
                <label for="MULTILINE">re.MULTILINE, re.M</label>
            </dt>
            <dd>
                When specified, the pattern character '^' matches at
                the beginning of the string and at the beginning of each line (immediately
                following each newline); and the pattern character '$' matches at the end of the
                string and at the end of each line (immediately preceding each newline). By
                default, '^' matches only at the beginning of the string, and '$' only at the
                end of the string and immediately before the newline (if any) at the end of the
                string.
            </dd>
            <dt>
                <input {{ 'checked="checked"' if DOTALL else '' }}
                       type="checkbox" name="DOTALL" id='DOTALL'>
                <label for="DOTALL">re.DOTALL, re.S</label>
            </dt>
            <dd>
                Make the '.' special character
                match any character at all, including a newline; without this flag, '.' will
                match anything except a newline.
            </dd>
            <dt>
                <input {{ 'checked="checked"' if UNICODE else '' }}
                       type="checkbox" name="UNICODE" id='UNICODE'>
                <label for="UNICODE">re.UNICODE, re.U</label>
            </dt>
            <dd>
                Make \w, \W, \b, \B, \d, \D, \s and \S dependent on the Unicode character
                properties database.
            </dd>
            <dt>
                <input {{ 'checked="checked"' if VERBOSE else '' }}
                       type="checkbox" name="VERBOSE" id='VERBOSE'>
                <label for="VERBOSE">re.VERBOSE, re.X</label>
            </dt>
            <dd>
            This flag allows you to write regular expressions that look nicer.
            Whitespace within
            the pattern is ignored, except when in a character class or preceded by an
            unescaped backslash, and, when a line contains a '#' neither in a character
            class or preceded by an unescaped backslash, all characters from the leftmost
            such '#' through the end of the line are ignored.

            That means that the two following regular expression objects that match a decimal
             number are functionally equal:

            a = re.compile(r"""\d +  # the integral part
                               \.    # the decimal point
                               \d *  # some fractional digits""", re.X)
            b = re.compile(r"\d+\.\d*")
            </dd>
        </dl>

     </details>


</div>

<p id='replace'>
    <label for="replace">Replace with: </label>
    <input type="text" name="replace" value="{{ replace }}" >
</p>

<p id='text'>
    <label for="text">Apply regex to: </label><br >
    <textarea name="text" class="text" required>{{ text }}</textarea>
    <div class="text hide">{{ text }}</div>
</p>

<div id="result">

    <span class='hide' id="markers" >
            {{ markers }}
    </span>

    %if code:
    <p>Code: <br >
    <code><pre>{{ code }}</pre></code>
    </p>
    %end
    %if result:
    <dl>
        %if hasattr(result, 'group'):
        <dt>match.group():</dt>
        <dd><code>{{ result.group() }}</code></dd>
        <dt>match.groupdict():</dt>
        <dd><code>{{ result.groupdict() }}</code></dd>
        %else:
        <dt>Result:</dt>
        <dd><code>{{ result }}</code></dd>
        %end

    </dl>
    %else:

        %if not error and regex:
        <p class='notice'>No match</p>
        %end

    %end

    %if error:
    <p class="error">{{ error }}</p>
    %end
</div>


<p id='submit'>
    <input type="submit" name="Send" value="Send" >
    <a href='#'>help</a>
</p>

<p id='download'>
  Too slow ?
  <a href="/static/regex_tester.py">Download the stand alone version</a>
</p>
</form>

<div id="help">

<p>
    From the official
    <a href="http://docs.python.org/library/re.html">
        Python documentation page on regular expressions
    </a>:
</p>

<table style="text-align: left; width: 100%;" border="1" cellpadding="2"
cellspacing="2">
<tbody>
<tr>
<th style="text-align: center;">'.'<br>
</th>
<td style="vertical-align: top;">(Dot.) In the default mode, this
matches any character except a newline. If the DOTALL flag has been
specified, this matches any character including a newline.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">'^'<br>
</th>
<td style="vertical-align: top;">(Caret.) Matches the start of
the string, and in MULTILINE mode also matches immediately after each
newline.<br>
</td>
</tr>
<tr>
<th style="text-align: center;">'$'<br>
</th>
<td style="vertical-align: top;">Matches the end of the string or
just before the newline at the end of the string, and in MULTILINE mode
also matches before a newline. foo matches both ‘foo’ and ‘foobar’,
while the regular expression foo$ matches only ‘foo’. More
interestingly, searching for foo.$ in 'foo1\nfoo2\n' matches ‘foo2’
normally, but ‘foo1’ in MULTILINE mode; searching for a single $ in
'foo\n' will find two (empty) matches: one just before the newline, and
one at the end of the string.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">'*'<br>
</th>
<td style="vertical-align: top;">Causes the resulting RE to match
0 or more repetitions of the preceding RE, as many repetitions as are
possible. ab* will match ‘a’, ‘ab’, or ‘a’ followed by any number of
‘b’s.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">'+'<br>
</th>
<td style="vertical-align: top;">Causes the resulting RE to match
1 or more repetitions of the preceding RE. ab+ will match ‘a’ followed
by any non-zero number of ‘b’s; it will not match just ‘a’.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">'?'<br>
</th>
<td style="vertical-align: top;">Causes the resulting RE to match
0 or 1 repetitions of the preceding RE. ab? will match either ‘a’ or
‘ab’.<br>
</td>
</tr>
<tr>
<th style="text-align: center;">*?, +?, ??<br>
</th>
<td style="vertical-align: top;">The '*', '+', and '?' qualifiers
are all greedy; they match as much text as possible. Sometimes this
behaviour isn’t desired; if the RE &lt;.*&gt; is matched against
'&lt;H1&gt;title&lt;/H1&gt;', it will match the entire string, and not
just '&lt;H1&gt;'. Adding '?' after the qualifier makes it perform the
match in non-greedy or minimal fashion; as few characters as possible
will be matched. Using .*? in the previous expression will match only
'&lt;H1&gt;'.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">{m}<br>
</th>
<td style="vertical-align: top;">Specifies that exactly m copies
of the previous RE should be matched; fewer matches cause the entire RE
not to match. For example, a{6} will match exactly six 'a' characters,
but not five.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">{m,n}<br>
</th>
<td style="vertical-align: top;">Causes the resulting RE to match
from m to n repetitions of the preceding RE, attempting to match as
many repetitions as possible. For example, a{3,5} will match from 3 to
5 'a' characters. Omitting m specifies a lower bound of zero, and
omitting n specifies an infinite upper bound. As an example, a{4,}b
will match aaaab or a thousand 'a' characters followed by a b, but not
aaab. The comma may not be omitted or the modifier would be confused
with the previously described form.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">{m,n}?<br>
<br>
</th>
<td style="vertical-align: top;">Causes the resulting RE to match
from m to n repetitions of the preceding RE, attempting to match as few
repetitions as possible. This is the non-greedy version of the previous
qualifier. For example, on the 6-character string 'aaaaaa', a{3,5} will
match 5 'a' characters, while a{3,5}? will only match 3 characters.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">'\'<br>
</th>
<td style="vertical-align: top;">Either escapes special
characters (permitting you to match characters like '*', '?', and so
forth), or signals a special sequence; special sequences are discussed
below.<br>
<br>
If you’re not using a raw string to express the pattern, remember that
Python also uses the backslash as an escape sequence in string
literals; if the escape sequence isn’t recognized by Python’s parser,
the backslash and subsequent character are included in the resulting
string. However, if Python would recognize the resulting sequence, the
backslash should be repeated twice. This is complicated and hard to
understand, so it’s highly recommended that you use raw strings for all
but the simplest expressions.<br>
</td>
</tr>
<tr>
<th style="text-align: center;">[]<br>
</th>
<td style="vertical-align: top;">Used to indicate a set of
characters. In a set:<br>
<br>
Characters can be listed individually, e.g. [amk] will match 'a', 'm',
or 'k'.<br>
Ranges of characters can be indicated by giving two characters and
separating them by a '-', for example [a-z] will match any lowercase
ASCII letter, [0-5][0-9] will match all the two-digits numbers from 00
to 59, and [0-9A-Fa-f] will match any hexadecimal digit. If - is
escaped (e.g. [a\-z]) or if it’s placed as the first or last character
(e.g. [a-]), it will match a literal '-'.<br>
Special characters lose their special meaning inside sets. For example,
[(+*)] will match any of the literal characters '(', '+', '*', or ')'.<br>
Character classes such as \w or \S (defined below) are also accepted
inside a set, although the characters they match depends on whether
LOCALE or UNICODE mode is in force.<br>
Characters that are not within a range can be matched by complementing
the set. If the first character of the set is '^', all the characters
that are not in the set will be matched. For example, [^5] will match
any character except '5', and [^^] will match any character except '^'.
^ has no special meaning if it’s not the first character in the set.<br>
To match a literal ']' inside a set, precede it with a backslash, or
place it at the beginning of the set. For example, both [()[\]{}] and
[]()[{}] will both match a parenthesis.<br>
</td>
</tr>
<tr>
<th style="text-align: center;">'|'<br>
</th>
<td style="vertical-align: top;">A|B, where A and B can be
arbitrary REs, creates a regular expression that will match either A or
B. An arbitrary number of REs can be separated by the '|' in this way.
This can be used inside groups (see below) as well. As the target
string is scanned, REs separated by '|' are tried from left to right.
When one pattern completely matches, that branch is accepted. This
means that once A matches, B will not be tested further, even if it
would produce a longer overall match. In other words, the '|' operator
is never greedy. To match a literal '|', use \|, or enclose it inside a
character class, as in [|].<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">(...)<br>
</th>
<td style="vertical-align: top;">Matches whatever regular
expression is inside the parentheses, and indicates the start and end
of a group; the contents of a group can be retrieved after a match has
been performed, and can be matched later in the string with the \number
special sequence, described below. To match the literals '(' or ')',
use \( or \), or enclose them inside a character class: [(] [)].<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">(?...)<br>
</th>
<td style="vertical-align: top;">This is an extension notation (a
'?' following a '(' is not meaningful otherwise). The first character
after the '?' determines what the meaning and further syntax of the
construct is. Extensions usually do not create a new group;
(?P&lt;name&gt;...) is the only exception to this rule. Following are
the currently supported extensions:<br>
<dl>
<dt>(?iLmsux)</dt>
<dd>(One or more letters from the set 'i', 'L', 'm', 's', 'u',
'x'.) The group matches the empty string; the letters set the
corresponding flags: re.I (ignore case), re.L (locale dependent), re.M
(multi-line), re.S (dot matches all), re.U (Unicode dependent), and
re.X (verbose), for the entire regular expression. (The flags are
described in Module Contents.) This is useful if you wish to include
the flags as part of the regular expression, instead of passing a flag
argument to the re.compile() function.<br>
<br>
Note that the (?x) flag changes how the expression is parsed. It should
be used first in the expression string, or after one or more whitespace
characters. If there are non-whitespace characters before the flag, the
results are undefined.<br>
</dd>
<dt>(?:...)</dt>
<dd>A non-capturing version of regular parentheses. Matches
whatever regular expression is inside the parentheses, but the
substring matched by the group cannot be retrieved after performing a
match or referenced later in the pattern.<br>
(?P&lt;name&gt;...)<br>
Similar to regular parentheses, but the substring matched by the group
is accessible within the rest of the regular expression via the
symbolic group name name. Group names must be valid Python identifiers,
and each group name must be defined only once within a regular
expression. A symbolic group is also a numbered group, just as if the
group were not named. So the group named id in the example below can
also be referenced as the numbered group 1.<br>
<br>
For example, if the pattern is (?P&lt;id&gt;[a-zA-Z_]\w*), the group
can be referenced by its name in arguments to methods of match objects,
such as m.group('id') or m.end('id'), and also by name in the regular
expression itself (using (?P=id)) and replacement text given to .sub()
(using \g&lt;id&gt;).<br>
</dd>
<dt>(?P=name)</dt>
<dd>Matches whatever text was matched by the earlier group
named name.</dd>
<dt>(?#...)</dt>
<dd>A comment; the contents of the parentheses are simply
ignored.</dd>
<dt>(?=...)</dt>
<dd>Matches if ... matches next, but doesn’t consume any of the
string. This is called a lookahead assertion. For example, Isaac
(?=Asimov) will match 'Isaac ' only if it’s followed by 'Asimov'.</dd>
<dt>(?!...)</dt>
<dd>Matches if ... doesn’t match next. This is a negative
lookahead assertion. For example, Isaac (?!Asimov) will match 'Isaac '
only if it’s not followed by 'Asimov'</dd>
<dt>(?&lt;=...)</dt>
<dd>Matches if the current position in the string is preceded
by a match for ... that ends at the current position. This is called a
positive lookbehind assertion. (?&lt;=abc)def will find a match in
abcdef, since the lookbehind will back up 3 characters and check if the
contained pattern matches. The contained pattern must only match
strings of some fixed length, meaning that abc or a|b are allowed, but
a* and a{3,4} are not. Note that patterns which start with positive
lookbehind assertions will never match at the beginning of the string
being searched; you will most likely want to use the search() function
rather than the match() function:<br>
<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; import re<br>
&gt;&gt;&gt; m = re.search('(?&lt;=abc)def', 'abcdef')<br>
&gt;&gt;&gt; m.group(0)<br>
'def'<br>
This example looks for a word following a hyphen:<br>
<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; m = re.search('(?&lt;=-)\w+', 'spam-egg')<br>
&gt;&gt;&gt; m.group(0)<br>
'egg'</dd>
<dt>(?&lt;!...)<br>
</dt>
<dd>Matches if the current position in the string is not
preceded by a match for .... This is called a negative lookbehind
assertion. Similar to positive lookbehind assertions, the contained
pattern must only match strings of some fixed length. Patterns which
start with negative lookbehind assertions may match at the beginning of
the string being searched.<br>
(?(id/name)yes-pattern|no-pattern)<br>
Will try to match with yes-pattern if the group with given id or name
exists, and with no-pattern if it doesn’t. no-pattern is optional and
can be omitted. For example, (&lt;)?(\w+@\w+(?:\.\w+)+)(?(1)&gt;) is a
poor email matching pattern, which will match with
'&lt;user@host.com&gt;' as well as 'user@host.com', but not with
'&lt;user@host.com'.<br>
<br>
</dd>
</dl>
</td>
</tr>
<tr>
<th style="text-align: center;">\number<br>
</th>
<td style="vertical-align: top;">Matches the contents of the
group of the same number. Groups are numbered starting from 1. For
example, (.+) \1 matches 'the the' or '55 55', but not 'the end' (note
the space after the group). This special sequence can only be used to
match one of the first 99 groups. If the first digit of number is 0, or
number is 3 octal digits long, it will not be interpreted as a group
match, but as the character with octal value number. Inside the '[' and
']' of a character class, all numeric escapes are treated as characters.<br>
</td>
</tr>
<tr>
<th style="text-align: center;">\A<br>
</th>
<td style="vertical-align: top;">Matches only at the start of the
string.<br>
</td>
</tr>
<tr>
<th style="text-align: center;">\b<br>
</th>
<td style="vertical-align: top;">Matches the empty string, but
only at the beginning or end of a word. A word is defined as a sequence
of alphanumeric or underscore characters, so the end of a word is
indicated by whitespace or a non-alphanumeric, non-underscore
character. Note that \b is defined as the boundary between \w and \W,
so the precise set of characters deemed to be alphanumeric depends on
the values of the UNICODE and LOCALE flags. Inside a character range,
\b represents the backspace character, for compatibility with Python’s
string literals.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">\B<br>
</th>
<td style="vertical-align: top;">Matches the empty string, but
only when it is not at the beginning or end of a word. This is just the
opposite of \b, so is also subject to the settings of LOCALE and
UNICODE.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">\d<br>
</th>
<td style="vertical-align: top;">When the UNICODE flag is not
specified, matches any decimal digit; this is equivalent to the set
[0-9]. With UNICODE, it will match whatever is classified as a decimal
digit in the Unicode character properties database.<br>
</td>
</tr>
<tr>
<th style="text-align: center;">\D<br>
</th>
<td style="vertical-align: top;">When the UNICODE flag is not
specified, matches any non-digit character; this is equivalent to the
set [^0-9]. With UNICODE, it will match anything other than character
marked as digits in the Unicode character properties database.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">\s<br>
</th>
<td style="vertical-align: top;">When the LOCALE and UNICODE
flags are not specified, matches any whitespace character; this is
equivalent to the set [ \t\n\r\f\v]. With LOCALE, it will match this
set plus whatever characters are defined as space for the current
locale. If UNICODE is set, this will match the characters [ \t\n\r\f\v]
plus whatever is classified as space in the Unicode character
properties database.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">\S<br>
</th>
<td style="vertical-align: top;">When the LOCALE and UNICODE
flags are not specified, matches any non-whitespace character; this is
equivalent to the set [^ \t\n\r\f\v] With LOCALE, it will match any
character not in this set, and not defined as space in the current
locale. If UNICODE is set, this will match anything other than [
\t\n\r\f\v] and characters marked as space in the Unicode character
properties database.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">\w<br>
</th>
<td style="vertical-align: top;">When the LOCALE and UNICODE
flags are not specified, matches any alphanumeric character and the
underscore; this is equivalent to the set [a-zA-Z0-9_]. With LOCALE, it
will match the set [0-9_] plus whatever characters are defined as
alphanumeric for the current locale. If UNICODE is set, this will match
the characters [0-9_] plus whatever is classified as alphanumeric in
the Unicode character properties database.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">\W<br>
</th>
<td style="vertical-align: top;">When the LOCALE and UNICODE
flags are not specified, matches any non-alphanumeric character; this
is equivalent to the set [^a-zA-Z0-9_]. With LOCALE, it will match any
character not in the set [0-9_], and not defined as alphanumeric for
the current locale. If UNICODE is set, this will match anything other
than [0-9_] and characters marked as alphanumeric in the Unicode
character properties database.<br>
<br>
</td>
</tr>
<tr>
<th style="text-align: center;">\Z<br>
</th>
<td style="vertical-align: top;">Matches only at the end of the
string.<br>
Most of the standard escapes supported by Python string literals are
also accepted by the regular expression parser:<br>
<br>
\a&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \b&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
\f&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \n<br>
\r&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
\v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \x<br>
\\<br>
Octal escapes are included in a limited form: If the first digit is a
0, or if there are three octal digits, it is considered an octal
escape. Otherwise, it is a group reference. As for string literals,
octal escapes are always at most three digits in length.&lt;<br>
<br>
</td>
</tr>
</tbody>
</table>

</div>

<div id='tooltip'>
</div><!-- / -->

<footer>
    <p>
        The <a href="http://www.python.org/">Python</a> regex tester use
        <a href="http://bottlepy.org">Bottle</a>,
        <a href="http://blueprintcss.org/">Bluepring CSS</a>
        and <a href="http://jquery.com/">jQuery</a> -
        Hosted on <a href="http://pythonanywhere.com">Python Anywhere</a>
    </p>
    <p>
        This program is distributed under the GPL 2:
        <a href="https://github.com/ksamuel/Python-regex-tester">get the source on GitHub</a> -
        Brought to  you by
        <a href="http://yeleman.com">Yeleman</a>,
        data collection experts from West Africa
    </p>
</footer><!-- / -->

</div>

</body>

<script src="/static/jquery.js" type="text/javascript"
        charset="utf-8" >
</script>
<script src="/static/behavior.js" type="text/javascript"
        charset="utf-8" >
</script>

</html>