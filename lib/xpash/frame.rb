module XPash
  class Frame
    def self.display(xpash)
      print "xpash:#{xpash.query} > "

      input = gets
      unless input
        puts
        next
      end

      result = xpash.eval(input.chomp)

      puts "=> #{result}" if result
    rescue XPash::ReturnSignal
    rescue Nokogiri::XML::XPath::SyntaxError => e
      puts "Error: #{e}"
    rescue OptionParser::InvalidOption => e
      puts "Error: #{e}. 'help COMMAND' may help you."
    rescue ArgumentError => e
      puts "Error: #{e}"
    rescue RuntimeError => e
      puts "Error: #{e}"
    end
  end

end
