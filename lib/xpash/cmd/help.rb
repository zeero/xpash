module XPash
  class Base
    def help(*args)
      # parse args
    end

    def optparse_ls!(args)
      @log.debug_var binding, :args
      opts = {}
      if ! @optparses[:ls]
        o = OptionParser.new(nil , 16)
        o.banner = "ls: Show matched elements."
        o.separator("Options:")
        o.on("-s", "--short", "Display elements with short format.") {
          opts[:s] = true
        }
        o.on("-h", "--help", "Show this help message.") {
          puts o.help
          opts[:end] = true
        }
        @optparses[:ls] = o
      end
      @optparses[:ls].parse!(args)
      @log.debug_var binding, :opts
      return opts
    end
  end
end
