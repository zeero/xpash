$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'optparse'
require 'logger'
require 'open-uri'

require 'rubygems'
require 'nokogiri'
require 'term/ansicolor'
require 'win32console' if RUBY_PLATFORM =~ /mswin|mingw|cygwin|bccwin|interix/i

require 'xpash/base'
require 'xpash/return_signal'
require 'xpash/cmd/cmd_optparse'
require 'xpash/ext/nokogiri_ext.rb'
require 'xpash/ext/logger_ext.rb'

include Term::ANSIColor
Term::ANSIColor::coloring = STDOUT.isatty

module XPash
  VERSION = '0.0.1'
end
