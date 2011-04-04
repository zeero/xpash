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
      return list unless list.kind_of? Nokogiri::XML::NodeSet
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
          "Without '-o' option, this option is ignored.")
        o.on("-f", "--format TYPE",
          "Specify dump format.",
          " ",
          "Format Types:",
          sprintf("  %-8s%s", "raw", "Default format."),
          sprintf("  %-8s%s", "csv", "Create csv data."),
          sprintf("  %-8s%s", "xml", "Create well-formed xml data."),
          sprintf("  %-8s%s", "xsl", "Create data by xsl."))
        @optparses[:dump] = o
      end
      opts = @optparses[:dump].parse!(args)
      @log.debug_var binding, :args, :opts
      return opts
    end

  end
end
