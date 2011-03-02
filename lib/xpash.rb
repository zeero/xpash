$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'optparse'
require 'logger'

require 'rubygems'
require 'nokogiri'

module XPash
  VERSION = '0.0.1'
end
