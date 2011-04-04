require 'xpash/cmd/commands'

module XPash
  class Base

    DEFAULT_PATH = "/"
    ROOT_PATH = "/"
    DEFAULT_NS = "xmlns"

    attr_reader :query

    def initialize(filepath, opts = {})
      # setup logger
      @log = Logger.new($stdout)
      @log.datetime_format = "%Y-%m-%d %H:%M:%S"
      @log.level = Logger::WARN unless $DEBUG

      # setup object variables
      @doc = Nokogiri(open(filepath).read)
      @query = DEFAULT_PATH
      @list = @doc.xpath(@query)
      @optparses = {}

      # initialization
      initialize_xmlns
      #Term::ANSIColor::coloring = opts[:color] && STDOUT.isatty

      @log.debug_var binding, :filepath
    end

    def eval(input)
      if /^ *$/ =~ input
        return
      end

      args = input.split
      command = args.shift
      @log.debug_var binding, :command, :args

      if self.respond_to?(command)
        self.send(command, *args)
      else
        raise "\'#{command}\' is not XPash command."
      end
    end

    def getPath(base, appendix)
      # remove prefix './' (except for './/')
      appendix.gsub!(/^\.\/([^\/]+)/) {|t| $1 }
      # remove suffix '/'
      appendix.gsub!(/([^\/]+)\/$/) {|t| $1 }

      case appendix
      when /^\//
        # absolute path
        return appendix
      when /^\.\.(\/|$)/
        # remove condition expression
        base_tmp = base.sub(/\[[^\[]+?\]$/, "")

        # go up
        if /(^.*[^\/]+)\/+.+?$/ =~ base_tmp
          new_base = $1
          new_apdx = appendix.sub(/^\.\./, "")
          @log.debug_var binding, :new_base, :new_apdx
          # apply recursively when have more up sign
          if /^\/(\.\.\/?.*)/ =~ new_apdx
            return getPath(new_base, $1)
          else
            return new_base + new_apdx
          end
        else
          return ROOT_PATH
        end
      when /^\[/
        # add condition
        return base + appendix
      when /^\.$/
        # return current
        return base
      when /^$/
        # return default
        return DEFAULT_PATH
      when /^\".*\"$/, /^\'.*\'$/
        # should add appendix only
        return base + Kernel.eval(appendix)
      else
        if /\/$/ =~ base
          return base + appendix
        else
          return base + "/" + appendix
        end
      end
    end

    def initialize_xmlns
      $xmlns = {}
      count = 0
      warning = {}

      ns_ary = @doc.xpath("//namespace::*").each do |ns|
        unless ns.prefix
          unless $xmlns.has_value?(ns.href)
            suffix = count == 0 ? "" : "." + count.to_s
            key = DEFAULT_NS + suffix
            $xmlns[key] = ns.href
            count += 1
          end
        else
          if $xmlns[ns.prefix] && $xmlns[ns.prefix] != ns.href
            warning[ns.prefix] = true
          else
            $xmlns[ns.prefix] = ns.href
          end
        end
      end
      @log.debug_var binding, "$xmlns"

      warning.each_key do |prefix|
        puts "Warning: XML namespace '#{prefix}' is duplicate."
      end
    end

    def self.xpath(filepath, query)
      doc = Nokogiri::HTML(open(filepath))
      return doc.xpath(query).map {|e| e.to_s}
    end

  end
end
