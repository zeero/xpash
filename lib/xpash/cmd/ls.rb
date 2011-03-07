module XPash
  class Base
    def ls(*args)
      # parse args
      o = get_optparse_ls
      o.parse!(args)

      @list.each do |e|
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
            children.each do |child|
              # TODO
              puts child.ls
            end
          end

          puts
        end
      end
      return
    end
    alias :list :ls
  end
end
