module XPash
  class CmdOptionParser < OptionParser
    attr_accessor :min_args, :default_opts

    def initialize(banner = nil, width = 16, indent = ' ' * 4)
      @min_args = 0
      @default_opts = {}
      super(banner, width, indent) {|o|
        o.on_tail("-h", "--help", "Show this help message.") {
          puts o.help
          raise ReturnSignal
        }
      }
    end

    def on(*opts)
      super(*opts) {|value|
        optname = opts.find {|long| /^--/ =~ long }
        optname ||= opts.find {|short| /^-/ =~ short }
        @opts[optname.sub(/^-+/, "").sub(/-/, "_").sub(/ .*/, "").to_sym] = value
        yield value if block_given?
      }
    end

    def parse!(argv)
      @opts = @default_opts.dup
      super(argv)
      if @min_args > argv.size
        raise ArgumentError.new "Wrong number of arguments. (#{argv.size} for #{@min_args})"
      end
      return @opts
    end

    def add_officious
    end

    alias :original_separator :separator
    def separator(string)
      original_separator("")
      original_separator(string)
    end

    def describe(string)
      original_separator(@summary_indent + string)
    end

  end
end
