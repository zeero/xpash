module XPash
  class Base
    def help(*args)
      # parse args
    end

    def get_optparse_ls
      if ! @optparses[:ls]
        o = OptionParser.new(nil , 16)
        o.banner = "ls: Show matched elements."
        o.separator("Options:")
        o.on("-h", "--help", "This help.") { puts o.help }
        @optparses[:ls] = o
      end
      return @optparses[:ls]
    end
  end
end
