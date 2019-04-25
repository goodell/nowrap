[![Travis CI build status](https://travis-ci.org/goodell/nowrap.svg?branch=master)](https://travis-ci.org/goodell/nowrap)

# nowrap

Takes input on stdin and copies it to stdout, truncating to the width of the
terminal as needed. This is very similar to <code>cut -c1-${COLUMNS}</code>
except that this script attempts to understand a limited set of terminal escape
sequences so that colorized output isn't prematurely truncated.

*Author*: Dave Goodell <davidjgoodell@gmail.com>

## Build Instructions

For convenience, a dependency-free "FatPacked" perl script is checked in as
`nowrap` in the top level of this repository.  If you make modifications and
wish to test them, run "make" followed by "make check".  The Makefile depends
on having a functional version of App::FatPacker::Simple installed from CPAN.

The script depends on [Text::CharWidth::PurePerl](https://github.com/goodell/text-charwidth-pureperl),
which isn't currently available via CPAN because CPAN is a PITA for
developers.  So a copy of that is also included in this repository.

-----------------------------------------------------------------------
Copyright (c) 2009-2019 Dave Goodell

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
