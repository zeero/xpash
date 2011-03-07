module XPash
  class Base
    def ls(*args)
      # parse args
      opts = optparse_ls!(args)
      return if opts[:end]

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
