module XPash
  class Base
    def grep(keyword, node = @doc)
      matches = node.xpath("//text()[contains(., '#{keyword}')]")
      if matches
        @log.debug %(#grep: matches => "#{matches.to_ary.join("\", \"")}")
        matches.each {|tnode|
          path = tnode.ancestors.reverse.map {|anc|
            anc.name unless anc.kind_of? Nokogiri::XML::Document
          }
          path << tnode.content
          puts path.join("/")
        }
      end
      return
    end
  end
end
