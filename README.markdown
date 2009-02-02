Semi-Static
===========

Semi-Static is yet another static site generator.  I've been playing around
with similar systems off and on for years, but its [Jekyll][] that finally
convinced me to build (and finish) one.  The main idea that I take from
Jekyll is using [Git][] as the “database”.  The idea from Jekyll that I'm
ignoring completely is avoiding [Ruby][] code evaluation at all costs — I'm
not running the thing on a server like [GitHub][] [Pages][], and it
eliminates a few libraries that I want to use.

At some point Semi-Static had a sister project, Semi-Live, that would serve
up data from the data source dynamically, probably via [Rails][].  I stopped
working on it not long after I first started, so don't expect to see it
following its sister off to my [projects][] page.

Features
--------

* Layouts can be [Haml][] or [ERB][] — but not [Liquid][].
* Stylesheets can be [Sass][] or raw CSS.
* Pages and posts can be [Maruku][] or raw HTML.
* Code highlighting by [Pygments][].

Installation
------------

The easiest way to install Semi-Static is via [RubyGems][]:

    $ sudo gem install zzot-semi-static -s http://gems.github.com/

Semi-Static requires the \`Haml\` and \`Maruku\` gems and the \`Pygments\`
library to be installed.

Usage
-----

    $ semi source-path \[output-path\]

License
-------

(The MIT License)

Copyright (c) 2009 Josh Dady

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[*CMS]:         Content Management System
[*CSS]:         Cascading Style Sheets
[*HTML]:        HyperText Markup Language

[semi-static]:  http://github.com/zzot/semi-static
[jekyll]:       http://github.com/mojombo/jekyll
[git]:          http://git-scm.com/
[github]:       http://github.com/
[pages]:        http://pages.github.com
[rails]:        http://rubyonrails.org/
[projects]:     http://github.com/zzot
[haml]:         http://haml.hamptoncatlin.com/
[sass]:         http://haml.hamptoncatlin.com/
[erb]:          http://www.ruby-doc.org/stdlib/libdoc/erb/rdoc/
[liquid]:       http://www.liquidmarkup.org/
[maruku]:       http://maruku.rubyforge.org/
[pygments]:     http://pygments.org/
[rubygems]:     http://www.rubygems.org/
[ruby]:         http://ruby-lang.org/
