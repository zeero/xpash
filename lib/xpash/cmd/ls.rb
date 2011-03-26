module XPash
  class Base
    def ls(*args)
      # parse args
      opts = optparse_ls!(args)

      # get query & list
      if args.empty?
        query = @query
        list = @list
      else
        query = getPath(@query, args.join(" "))
        list = @doc.xpath(query)
      end
      raise "No such node: #{query}" if list.empty?

      # display
      list.each do |e|
        # remove condition expression
        query_tmp = query.sub(/\[[^\[]+?\]$/, "")

        # print element information
        if /(.*\/+)[^\/]+?$/ =~ query_tmp
          path = $1
        else
          # when target is '/'
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
      return list.size
    end
    alias :list :ls

    def optparse_ls!(args)
      unless @optparses[:ls]
        o = CmdOptionParser.new
        o.banner = "Usage: ls [OPTION] [QUERY]"
        o.separator("Options:")
        o.on("-s", "--short", "Display elements with short format.")
        @optparses[:ls] = o
      end
      opts = @optparses[:ls].parse!(args)
      @log.debug_var binding, :args, :opts
      return opts
    end

  end
end
