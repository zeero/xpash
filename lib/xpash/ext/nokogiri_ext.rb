class Nokogiri::XML::Node
  def ls(opts = {})
    return self.name
  end
end

class Nokogiri::XML::Attr
  def ls(opts = {})
  end
end

class Nokogiri::XML::Text
  def ls(opts = {})
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
      attr_a.each do |key, value|
        attr += " and @#{key}=\"#{value}\""
      end
      exp += "[#{attr}]"
    end

    return exp
  end
end
