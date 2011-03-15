module XPash
  class Base
    def cd(*args)
      # parse args
      opts = optparse_cd!(args)
      return if opts[:end]

      query = getPath(@query, args.to_s)

      @list = @doc.xpath(query)
      @query = query
      return @list.size
    end

    def optparse_cd!(args)
      @cmd_opts = {}
      if ! @optparses[:cd]
        o = OptionParser.new(nil , 16)
        o.banner = "cd: Change datum point."
        o.separator("Options:")
        o.on("-h", "--help", "Show this help message.") {
          puts o.help
          @cmd_opts[:end] = true
        }
        @optparses[:cd] = o
      end
      @optparses[:cd].parse!(args)
      @log.debug_var binding, :args, "@cmd_opts"
      raise ArgumentError if args.size > 1
      return @cmd_opts
    rescue Exception => e
      raise e.to_s
    end

  end
end
