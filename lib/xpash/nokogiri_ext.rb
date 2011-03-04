class Nokogiri::XML::Document
end
class Nokogiri::XML::Attr
end
class Nokogiri::XML::Text
end
class Nokogiri::XML::Element
  def ls(xpath, args = nil)
    # print xpath without attributes
    print xpath.gsub(/\[.+?\]$/, "")

    # print attributes
    attr_a = self.attributes
    if attr_a.size > 0
      first = attr_a.shift
      attr = "@#{first[0]}=\"#{first[1]}\""
      attr_a.each {|key, value|
        attr += " and @#{key}=\"#{value}\""
      }
      print "[#{attr}]"
    end

    # print childs
    children = self.children
    if children.size > 0
      puts ":"
      children.each {|child|
        puts child.name
      }
    end

    puts
  end
end
