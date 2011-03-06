module XPash
  class Base
    def ls(*args)
      # parse args
      OptionParser.new(nil , 16) {|o|
        o.banner = "ls: Show matched elements."
        o.separator("Options:")
        o.on("-h", "--help", "This help.") {puts o.help; return}
        o.parse!(args)
      }

      @list.each {|e|
        case e
        when Nokogiri::XML::Element
          # print element information
          if /(.*\/+)[^\/]+?$/ =~ @query
            path = $1
          else
            path = @query
          end
          print %(#{path}#{e.ls(nil)})

          # print childs
          children = e.children
          if children.size > 0
            puts ":"
            children.each {|child|
              # TODO
              puts child.ls
            }
          end

          puts
        end
      }
      return
    end
    alias :list :ls
  end
end
