require 'xpash/cmd/cd'

module XPash
  class Base
    def ls(args = nil)
      if args
        args_a = args.split
        OptionParser.new(nil , 16) {|o|
          o.banner = "ls: List matched elements themselves and their child."
          o.separator("Options:")
          o.on("-h", "--help", "This help.") {puts o.help; return}
          o.parse!(args_a)
        }
      end

      @list.each {|e|
        case e
        when Nokogiri::XML::Element
          e.ls(@query, args)
        end
      }
      return
    end
    alias :list :ls
  end
end
