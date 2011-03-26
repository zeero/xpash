# Library Preparation

begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'xpash'

Term::ANSIColor::coloring = false


# Contants

FIXTURE_DIR = "#{File.dirname(__FILE__)}/fixture"
FIXTURE_URL = "http://www.ruby-lang.org/"


# Helper methods

def get_fixture(filename = "default.html")
  return XPash::Base.new(FIXTURE_DIR + "/" + filename)
end

def prepare_stdout
  @stdout_io = StringIO.new
  $stdout = @stdout_io
end

def read_stdout
  @stdout_io.rewind
  return @stdout_io.read
end

