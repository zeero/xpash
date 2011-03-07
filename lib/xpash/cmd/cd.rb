module XPash
  class Base
    def cd(*args)
      # parse args
      # TODO
      path = args.to_s

      case path
      when /^\//
        # absolute path
        query = path
      when /^\.\./
        # go up
        if /(^.*[^\/]+)\/+.+?$/ =~ @query
          query = $1
        else
          query = ROOT_PATH
        end
      when /^\[/
        # add condition
        query = @query + path
      else
        if /\/$/ =~ @query
          query = @query + path
        else
          query = @query + "/" + path
        end
      end

      @list = @doc.xpath(query)
      @query = query
      @list.size
    end
  end
end
