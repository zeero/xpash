module XPash
  class Base
    def ls(*args)
      # parse args
      opts = optparse_ls!(args)
      return if opts[:end]

      # get query & list
      if ! args[0]
        query = @query
        list = @list
      else
        query = getPath(@query, args[0])
        list = @doc.xpath(query)
      end

      # display
      list.each do |e|
        # print element information
        if /(.*\/+)[^\/]+?$/ =~ query
          path = $1
        else
          path = query
        end
        print %(#{path}#{e.ls(opts)})

        # print childs
        children = e.children
        if children.size > 0
          puts ":"
          children.each do |child|
            puts child.ls(opts)
          end
        end

        puts
      end
      return
    end
    alias :list :ls

    def optparse_ls!(args)
      @cmd_opts = {}
      if ! @optparses[:ls]
        o = OptionParser.new(nil , 16)
        o.banner = "Usage: ls [OPTION] [QUERY]"
        o.separator("Options:")
        o.on("-s", "--short", "Display elements with short format.") {
          @cmd_opts[:short] = true
        }
        o.on("-h", "--help", "Show this help message.") {
          puts o.help
          @cmd_opts[:end] = true
        }
        @optparses[:ls] = o
      end
      @optparses[:ls].parse!(args)
      @log.debug_var binding, :args, "@cmd_opts"
      return @cmd_opts
    end

  end
end
