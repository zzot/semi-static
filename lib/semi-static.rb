# Core requirements
require 'erb'
require 'yaml'

# Gem requirements
require 'rubygems'
require 'haml'
require 'maruku'

$LOAD_PATH.unshift File.dirname(__FILE__)

# Core extensions
require 'semi-static/core_ext/hash'

# My classes and modules
require 'semi-static/base'
require 'semi-static/convertable'
require 'semi-static/layout'
require 'semi-static/page'
require 'semi-static/post'
require 'semi-static/categories'
require 'semi-static/site'
