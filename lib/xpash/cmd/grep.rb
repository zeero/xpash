module XPash
  class Base
    def grep(keyword)
      matches = @doc.xpath("//*[contains(text(), '#{keyword}')]/text()")
      if matches
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
