$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'optparse'
require 'logger'

require 'rubygems'
require 'nokogiri'

require 'xpash/base'
require 'xpash/cmd/commands'
require 'xpash/nokogiri_ext'

module XPash
  VERSION = '0.0.1'
end
