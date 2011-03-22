module XPash
  class Base
    def grep(*args)
      # parse args
      opts = optparse_grep!(args)

      keyword = args[0]
      if opts[:all]
        node_ary = [@doc]
      elsif args[1]
        node_ary = @doc.xpath(getPath(@query, args[1]))
      else
        node_ary = @list
      end

      matches = node_ary.map {|node| node.xpath(".//text()[contains(., '#{keyword}')]")}
      @log.debug_var binding, :matches
      matches.each do |nodeset|
        nodeset.each do |tnode|
          path = tnode.ancestors.reverse.map {|anc|
            anc.name unless anc.kind_of? Nokogiri::XML::Document
          }
          path << tnode.ls({:short => opts[:short]})
          puts path.join("/")
        end
      end
      return matches.flatten.size
    end

    def optparse_grep!(args)
      unless @optparses[:grep]
        o = CmdOptionParser.new(1, nil, 20)
        o.banner = "Usage: grep [OPTION] KEYWORD [PATH]"
        o.separator("Options:")
        o.on("-a", "--all", "Search from document root.")
        o.on("-s", "--short", "Display elements with short format.")
        @optparses[:grep] = o
      end
      opts = @optparses[:grep].parse!(args)
      @log.debug_var binding, :args, :opts
      return opts
    end

  end
end
