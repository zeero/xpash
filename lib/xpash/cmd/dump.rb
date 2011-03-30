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
        o = CmdOptionParser.new(nil, 22)
        o.banner = "Usage: dump [OPTION] [QUERY]"
        o.separator("Options:")
        o.on("-a", "--all", "Show all document.")
        o.on("-o", "--output FILENAME",
          "Write output to file instead of the standard output.",
          "File will be created or overwritten by default.")
        o.on("--append",
          "When use with '-o' option, append output",
          "to the end of the file.",
          "Without '-o' option, this option make no sense.")
        @optparses[:dump] = o
      end
      opts = @optparses[:dump].parse!(args)
      @log.debug_var binding, :args, :opts
      return opts
    end

  end
end
