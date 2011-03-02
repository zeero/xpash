# Add this library to $LOAD_PATH
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'logger'
require 'optparse'

require 'rubygems'
require 'nokogiri'

class XPash

  VERSION = '0.0.1'

  DEFAULT_PATH = "//"
  ROOT_PATH = "/"

  attr_reader :query

  def initialize(filepath)
    @doc = Nokogiri::HTML(open(filepath))
    @query = DEFAULT_PATH
    @list = Array.new

    @log = Logger.new(STDOUT)
    @log.level = Logger::WARN unless $DEBUG
  end

  def eval(input)
    if "" == input
      return
    end

    input_a = input.split
    command = input_a.shift
    args = input_a.join(" ")
    @log.debug("command => #{command}, args => #{args}")

    if self.respond_to?(command)
      self.send(command, args)
    else
      puts "Error: \'#{command}\' is not xpash command."
    end
  end

  def cd(path = nil)

    case path
    when /^\//
      # absolute path
      query = path
    when /^\.\./
      # go up
      if /(^.*[^\/]+)\/+.+?$/ =~ @query
        query = $1
      else
        query = ROOT_PATH
      end
    when /^\[/
      # add condition
      query = @query + path
    else
      if /\/$/ =~ @query
        query = @query + path
      else
        query = @query + "/" + path
      end
    end

    @list = @doc.xpath(query)
    @query = query
    @list.size
  end

  def ls(args = nil)
    if args
      args_a = args.split
      OptionParser.new(nil , 16) {|o|
        o.banner = "ls: List matched elements themselves and their child."
        o.separator("Options:")
        o.on("-h", "--help", "This help.") {puts o.help; return}
        o.parse!(args_a)
      }
    end

    @list.each {|e|
      case e
      when Nokogiri::XML::Element
        e.ls(@query, args)
      end
    }
    return
  end
  alias :list :ls

  def up(args = nil)
  end

  def exit(args = nil)
    Kernel.exit
  end
  alias :quit :exit

  def self.xpath(filepath, query)
    doc = Nokogiri::HTML(open(filepath))
    return doc.xpath(query).map {|e| e.to_s}
  end
end

class Nokogiri::XML::Document
end
class Nokogiri::XML::Attr
end
class Nokogiri::XML::Text
end
class Nokogiri::XML::Element
  def ls(xpath, args = nil)
    # print xpath without attributes
    print xpath.gsub(/\[.+?\]$/, "")

    # print attributes
    attr_a = self.attributes
    if attr_a.size > 0
      first = attr_a.shift
      attr = "@#{first[0]}=\"#{first[1]}\""
      attr_a.each {|key, value|
        attr += " and @#{key}=\"#{value}\""
      }
      print "[#{attr}]"
    end

    # print childs
    children = self.children
    if children.size > 0
      puts ":"
      children.each {|child|
        puts child.name
      }
    end

    puts
  end
end



if __FILE__ == $0

  if ARGV[0]
    if File::ALT_SEPARATOR
      filepath = ARGV[0].gsub(File::ALT_SEPARATOR, File::SEPARATOR)
    else
      filepath = ARGV[0]
    end
  else
    #puts "file path?"
    filepath = "#{File.dirname($0)}/../test/test.html"
  end
  xpash = XPash.new(filepath)

  if ARGV[1]
    xpash.cd(ARGV[1])
    xpash.ls
    exit
  end

  # main loop
  Signal.trap(:INT, nil)
  while true do
    begin
      print "xpash[#{xpash.query}]> "

      input = gets
      unless input
        puts
        next
      end

      result = xpash.eval(input.chomp)

      puts "=> #{result}" if result
    rescue Nokogiri::XML::XPath::SyntaxError => e
      puts "Error: #{e}"
    end
  end

end

# >> Apache Chunked Encoding Remote Overflow
# >> Apache &lt; 1.3.27 Multiple Vulnerabilities (DoS, XSS)
# >> Apache &lt; 1.3.37 mod_rewrite LDAP Protocol URL Handling Overflow
# >> Apache &lt; 1.3.28 Multiple Vulnerabilities (DoS, ID)
# >> Apache &lt; 1.3.29 Multiple Modules Local Overflow
# >> PHP &lt; 4.4.3 / 5.1.4 Multiple Vulnerabilities
# >> PHP &lt; 4.3.3 Multiple Vulnerabilities
# >> PHP &lt; 4.3.11 / 5.0.3 Multiple Unspecified Vulnerabilities
# >> PHP &lt; 4.4.9 Multiple Vulnerabilities
# >> PHP &lt; 4.4.5 Multiple Vulnerabilities
# >> PHP &lt; 4.4.1 / 5.0.6 Multiple Vulnerabilities
# >> PHP &lt; 4.3.10 / 5.0.3 Multiple Vulnerabilities
# >> mod_ssl ssl_util_uuencode_binary Remote Overflow
# >> Apache mod_ssl ssl_engine_log.c mod_proxy Hook Function Remote Format inputing
