module XPash
  class Base
    def cd(*args)
      # parse args
      # TODO
      path = args.to_s

      query = getPath(@query, path)

      @list = @doc.xpath(query)
      @query = query
      @list.size
    end
  end
end
