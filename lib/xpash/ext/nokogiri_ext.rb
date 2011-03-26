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
    exp = ""

    # namespace
    if $xmlns
      if self.namespace
        if self.namespace.prefix
          exp += self.namespace.prefix
        else
          exp += $xmlns.index(self.namespace.href)
        end
        exp += ":"
      end
    end

    # tag
    exp += self.name

    # attributes expression
    unless opts[:short]
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
    unless opts[:short]
      return %(text\(\)[.='#{self.content.gsub(/\n/, '\n')}'])
    else
      return "text()"
    end
  end
end

class Nokogiri::XML::Comment
  def ls(opts = {})
    unless opts[:short]
      return %(comment\(\)[.='#{self.content.gsub(/\n/, '\n')}'])
    else
      return "comment()"
    end
  end
end

class Nokogiri::XML::ProcessingInstruction
  def ls(opts = {})
    unless opts[:short]
      return %(processing-instruction\('#{self.name}'\))
    else
      return "processing-instruction()"
    end
  end
end

