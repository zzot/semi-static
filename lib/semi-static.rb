module SemiStatic
  VERSION = '0.0.1'
end

$LOAD_PATH.unshift File.dirname(__FILE__)
require 'semi-static/base'
require 'semi-static/layout'
require 'semi-static/site'