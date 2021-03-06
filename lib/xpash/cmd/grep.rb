module XPash
  class Base
    def grep(*args)
      # parse args
      opts = optparse_grep!(args)

      keyword = args[0]
      if opts[:all]
        query = ROOT_PATH
        node_ary = [@doc]
      elsif args[1]
        query = getPath(@query, args[1])
        node_ary = @doc.xpath(query, $xmlns)
        return node_ary unless node_ary.kind_of? Nokogiri::XML::NodeSet
      else
        query = @query
        node_ary = @list
      end
      @log.debug_var binding, :query, "node_ary.size"

      matches = []
      node_ary.each do |node|
        nodeset = node.xpath(".//text()[contains(., '#{keyword}')]")
        nodeset.each do |tnode|
          matches << tnode
          path = [tnode.ls({:long => opts[:long]})]
          tnode.ancestors.each do |anc|
            break if anc.eql? node
            path << anc.ls
          end
          @log.debug_var binding, :path
          puts getPath(query, path.reverse.join("/"))
        end
      end
      @log.debug_var binding, :matches
      return matches.size
    end

    def optparse_grep!(args)
      unless @optparses[:grep]
        o = CmdOptionParser.new(nil, 20)
        o.banner = "Usage: grep [OPTION] KEYWORD [PATH]"
        o.min_args = 1
        o.separator("Options:")
        o.on("-a", "--all", "Search from document root.")
        o.on("-l", "--long", "Display elements with long format.")
        @optparses[:grep] = o
      end
      opts = @optparses[:grep].parse!(args)
      @log.debug_var binding, :args, :opts
      return opts
    end

  end
end
