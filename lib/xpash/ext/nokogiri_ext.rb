class Nokogiri::XML::Node

  def ls(opts = {})
    return self.name
  end

  def _ls(exp = {}, opts = {})
    exp[:short] ||= "node()"
    exp[:short_color] ||= Term::ANSIColor.yellow
    exp[:long_start] ||= "[.='"
    exp[:long_end] ||= "']"
    exp[:long_color] ||= Term::ANSIColor.magenta

    unless opts[:short]
      return exp[:short_color] + exp[:short] + Term::ANSIColor.reset +
        exp[:long_start] +
        exp[:long_color] + exp[:long_content] + Term::ANSIColor.reset +
        exp[:long_end]
    else
      return exp[:short_color] + exp[:short] + Term::ANSIColor.reset
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
    return cyan("@" + self.name) + "=\"" + magenta(self.value) + "\""
  end
end

class Nokogiri::XML::Text
  def ls(opts = {})
    exp = Hash.new
    exp[:short] = "text()"
    exp[:long_content] = self.content.gsub(/\n/, '\n')
    return _ls(exp, opts)
  end
end

class Nokogiri::XML::Comment
  def ls(opts = {})
    exp = Hash.new
    exp[:short] = "comment()"
    exp[:long_content] = self.content.gsub(/\n/, '\n')
    return _ls(exp, opts)
  end
end

class Nokogiri::XML::ProcessingInstruction
  def ls(opts = {})
    exp = Hash.new
    exp[:short] = "processing-instruction"
    exp[:long_start] = "("
    exp[:long_content] = self.name
    exp[:long_end] = ")"
    return _ls(exp, opts)
  end
end

