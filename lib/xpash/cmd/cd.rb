module XPash
  class Base
    def cd(*args)
      # parse args
      opts = optparse_cd!(args)
      return if opts[:end]

      query = getPath(@query, args.join(" "))
      list = @doc.xpath(query)
      raise "No such node: #{query}" if list.empty?

      @list = list
      @query = query
      return @list.size
    end

    def optparse_cd!(args)
      @cmd_opts = {}
      unless @optparses[:cd]
        o = OptionParser.new(nil , 16)
        o.banner = "Usage: cd [OPTION] [QUERY]"
        o.separator("Options:")
        o.on("-h", "--help", "Show this help message.") {
          puts o.help
          @cmd_opts[:end] = true
        }
        @optparses[:cd] = o
      end
      @optparses[:cd].parse!(args)
      @log.debug_var binding, :args, "@cmd_opts"
      return @cmd_opts
    rescue Exception => e
      raise e.to_s
    end

  end
end
