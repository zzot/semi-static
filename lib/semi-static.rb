# Core requirements
require 'erb'
require 'tempfile'
require 'time'
require 'yaml'

# Gem requirements
require 'rubygems'
require 'haml'
require 'sass'
require 'maruku'

$LOAD_PATH.unshift File.dirname(__FILE__)

# Core extensions
require 'semi-static/core_ext/hash'

# My classes and modules
require 'semi-static/base'
require 'semi-static/pygmentize'
require 'semi-static/convertable'
require 'semi-static/layout'
require 'semi-static/stylesheet'
require 'semi-static/page'
require 'semi-static/post'
require 'semi-static/snippet'
require 'semi-static/posts'
require 'semi-static/index'
require 'semi-static/tags'
require 'semi-static/statistics'
require 'semi-static/site'

##
# :title: Semi Static
#
# Semi Static is yet another static site generator.  I've been playing around
# with similar systems off and on for years, but it's
# Jekyll[http://github.com/mojombo/jekyll] that finally convinced me to build
# (and finish) one for myself.  The main idea that I take from Jekyll is using
# Git[http://git-scm.com/] as the database.  The idea from Jekyll that I'm not
# adopting is avoiding Ruby[http://ruby-lang.org/] code evaluation at all
# costs — I'm not letting other people feed documents into it (as
# GitHub[http://github.com/] Pages[http://pages.github.com] does), so I don't
# need to protect myself from them.
#
# At some point Semi Static had a sister project, Semi Live, that would generate
# the site dynamically (probably via Rails[http://rubyonrails.org/]).  I stopped
# working on it not long after I first started, so don't expect to see it on my
# projects[http://github.com/zzot] page.
#
# == Features
#
# * Layouts can be Haml[http://haml.hamptoncatlin.com/] or
#   ERB[http://www.ruby-doc.org/stdlib/libdoc/erb/rdoc/] — but not
#   Liquid[http://www.liquidmarkup.org/].
# * Stylesheets can be Sass[http://haml.hamptoncatlin.com/] or raw CSS.
# * Pages and posts can be Maruku[http://maruku.rubyforge.org/] or raw HTML.
# * Code highlighting by Pygments[http://pygments.org/].
# 
# == Installation
# 
# The easiest way to install Semi-Static is via RubyGems[http://www.rubygems.org/]:
# 
#     $ sudo gem install zzot-semi-static -s http://gems.github.com/
# 
# Semi-Static requires the \`Haml\` and \`Maruku\` gems and the \`Pygments\`
# library to be installed.
# 
# == Usage
# 
#     $ semi source-path \[output-path\]
# 
# == License
# 
# (The MIT License)
# 
# Copyright (c) 2009 Josh Dady
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module SemiStatic
end
