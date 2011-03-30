module XPash
  class Base

    def dump(*args)
      # parse args
      opts = optparse_dump!(args)

      # get query & list
      if args.empty?
        query = @query
        list = @list
      else
        query = getPath(@query, args.join(" "))
        list = @doc.xpath(query, $xmlns)
      end
      raise "No such node: #{query}" if list.empty?

      # display raw data
      list.each_with_index do |e, i|
        puts negative(query + ":")
        puts e
      end
      return
    end

    def optparse_dump!(args)
      unless @optparses[:dump]
        o = CmdOptionParser.new
        o.banner = "Usage: dump [OPTION] [QUERY]"
        o.separator("Options:")
        o.on("-a", "--all", "Show all document.")
        @optparses[:dump] = o
      end
      opts = @optparses[:dump].parse!(args)
      @log.debug_var binding, :args, :opts
      return opts
    end

  end
end
