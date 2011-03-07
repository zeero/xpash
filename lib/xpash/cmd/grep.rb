module XPash
  class Base
    def grep(keyword, node = @doc)
      matches = node.xpath("//text()[contains(., '#{keyword}')]")
      if matches
        @log.debug_var binding, :matches
        matches.each {|tnode|
          path = tnode.ancestors.reverse.map {|anc|
            anc.name unless anc.kind_of? Nokogiri::XML::Document
          }
          path << tnode.ls
          puts path.join("/")
        }
      end
      return
    end
  end
end
