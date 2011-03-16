class Nokogiri::XML::Node
  def ls(opts = {})
    return self.name
  end
end

class Nokogiri::XML::Attr
  def ls(opts = {})
    return "@#{self.name}=\"#{self.value}\""
  end
end

class Nokogiri::XML::Text
  def ls(opts = {})
    return %(text()[.="#{self.content.gsub(/\n/, "\\n")}"])
  end
end

class Nokogiri::XML::Element
  def ls(opts = {})
    exp = self.name

    # get attributes expression
    attr_a = self.attributes
    if attr_a.size > 0
      attr = attr_a.shift[1].ls
      attr_a.each_value do |a|
        attr += " and #{a.ls}"
      end
      exp += "[#{attr}]"
    end

    return exp
  end
end
