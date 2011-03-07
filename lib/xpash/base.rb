require 'xpash/cmd/commands'

module XPash
  class Base

    DEFAULT_PATH = "//"
    ROOT_PATH = "/"

    attr_reader :query

    def initialize(filepath)
      @doc = Nokogiri::HTML(open(filepath))
      @query = DEFAULT_PATH
      @list = Array.new

      @log = Logger.new($stdout)
      @log.datetime_format = "%Y-%m-%d %H:%M:%S"
      @log.level = Logger::WARN unless $DEBUG
      @log.debug_var binding, :filepath
    end

    def eval(input)
      if "" == input
        return
      end

      input_a = input.split
      command = input_a.shift
      args = input_a.join(" ")
      @log.debug_var binding, :command, :args

      if self.respond_to?(command)
        self.send(command, args)
      else
        raise "\'#{command}\' is not xpash command."
      end
    end

    def self.xpath(filepath, query)
      doc = Nokogiri::HTML(open(filepath))
      return doc.xpath(query).map {|e| e.to_s}
    end
  end
end
