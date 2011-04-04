class Nokogiri::XML::Node
  LS_SHORT = "node()"
  LS_LONG_START = "[.='"
  LS_LONG_END = "']"

  def ls(opts = {})
    @exp_long_content ||= self.name
    unless opts[:short]
      return yellow(self.class::LS_SHORT) +
        self.class::LS_LONG_START +
        magenta(@exp_long_content) +
        self.class::LS_LONG_END
    else
      return yellow(self.class::LS_SHORT)
    end
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
    exp = blue(exp + self.name)

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
    return cyan("@" + self.name) + "='" + magenta(self.value) + "'"
  end
end

class Nokogiri::XML::Text
  LS_SHORT = "text()"

  def ls(opts = {})
    @exp_long_content ||= self.content.gsub(/\n/, '\n')
    super(opts)
  end
end

class Nokogiri::XML::Comment
  LS_SHORT = "comment()"

  def ls(opts = {})
    @exp_long_content ||= self.content.gsub(/\n/, '\n')
    super(opts)
  end
end

class Nokogiri::XML::ProcessingInstruction
  LS_SHORT = "processing-instruction"
  LS_LONG_START = "("
  LS_LONG_END = ")"

  def ls(opts = {})
    @exp_long_content ||= self.name
    super(opts)
  end
end

