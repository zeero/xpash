module XPash
  class Base
    def cd(*args)
      # parse args
      opts = optparse_cd!(args)

      query = getPath(@query, args.join(" "))
      list = @doc.xpath(query, $xmlns)
      raise "No such node: #{query}" if list.empty?

      @list = list
      @query = query
      return @list.size
    end

    def optparse_cd!(args)
      unless @optparses[:cd]
        o = CmdOptionParser.new
        o.banner = "Usage: cd [OPTION] [QUERY]"
        o.separator("Options:")
        @optparses[:cd] = o
      end
      opts = @optparses[:cd].parse!(args)
      @log.debug_var binding, :args, :opts
      return opts
    end

  end
end
