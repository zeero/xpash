module XPash
  class Frame
    def self.display(xpash)
      print "xpash:#{xpash.query} > "

      input = $stdin.gets
      unless input
        puts
        return
      end

      result = xpash.eval(input.chomp)

      puts "=> #{result}" if result
    rescue XPash::ReturnSignal
    rescue OptionParser::InvalidOption => e
      puts "Error: #{e}. 'help COMMAND' may help you."
    rescue => e
      puts "Error: #{e}"
    end
  end

end
