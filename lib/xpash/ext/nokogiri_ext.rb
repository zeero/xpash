class Nokogiri::XML::Document
end
class Nokogiri::XML::Attr
end
class Nokogiri::XML::Text
  def ls
    return %(text()[.="#{self.content.gsub(/\n/, "")}"])
  end
end
class Nokogiri::XML::Element
  def ls(opts = {})
    exp = self.name

    # get attributes expression
    attr_a = self.attributes
    if attr_a.size > 0
      first = attr_a.shift
      attr = "@#{first[0]}=\"#{first[1]}\""
      attr_a.each {|key, value|
        attr += " and @#{key}=\"#{value}\""
      }
      exp += "[#{attr}]"
    end

    return exp
  end
end
