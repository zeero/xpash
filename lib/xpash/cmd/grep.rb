module XPash
  class Base
    def grep(*args)
      # parse args
      # TODO

      keyword = args[0]
      if args[1]
        # BUG
        node_ary = @list.map {|node| node.xpath("./" + args[1])}
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
          path << tnode.ls
          puts path.join("/")
        end
      end
      return matches.flatten.size
    end
  end
end
