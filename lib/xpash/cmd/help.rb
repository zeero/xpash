module XPash
  class Base
    def help(*args)
      # parse args
    end

    def optparse_ls!(args)
      @cmd_opts = {}
      if ! @optparses[:ls]
        o = OptionParser.new(nil , 16)
        o.banner = "ls: Show matched elements."
        o.separator("Options:")
        o.on("-s", "--short", "Display elements with short format.") {
          @cmd_opts[:s] = true
        }
        o.on("-h", "--help", "Show this help message.") {
          puts o.help
          @cmd_opts[:end] = true
        }
        @optparses[:ls] = o
      end
      @optparses[:ls].parse!(args)
      @log.debug_var binding, :args, "@cmd_opts"
      return @cmd_opts
    end
  end
end
