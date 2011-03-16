class Nokogiri::XML::Node
  def ls(opts = {})
    return self.name
  end
end

class Nokogiri::XML::Document
  def ls(opts = {})
    return ""
  end
end

class Nokogiri::XML::Element
  def ls(opts = {})
    exp = self.name

    if ! opts[:short]
      # get attributes expression
      attr_a = self.attributes
      if attr_a.size > 0
        attr = attr_a.shift[1].ls
        attr_a.each_value do |a|
          attr += " and #{a.ls}"
        end
        exp += "[#{attr}]"
      end
    end

    return exp
  end
end

class Nokogiri::XML::Attr
  def ls(opts = {})
    return %(@#{self.name}="#{self.value}")
  end
end

class Nokogiri::XML::Text
  def ls(opts = {})
    if ! opts[:short]
      return %(text\(\)[.="#{self.content.gsub(/\n/, '\n')}"])
    else
      return "text()"
    end
  end
end

