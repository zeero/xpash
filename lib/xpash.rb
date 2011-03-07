$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'optparse'
require 'logger'

require 'rubygems'
require 'nokogiri'

require 'xpash/base'
require 'xpash/ext/nokogiri_ext.rb'
require 'xpash/ext/logger_ext.rb'

module XPash
  VERSION = '0.0.1'
end
