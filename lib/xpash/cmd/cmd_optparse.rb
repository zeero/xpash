module XPash
  class CmdOptionParser < OptionParser

    def initialize(banner = nil, width = 16, indent = ' ' * 4)
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
        @opts[optname.sub(/^-+/, "").sub(/ .*/, "").to_sym] = value
        yield value if block_given?
      }
    end

    def parse!(argv)
      @opts = {}
      super(argv)
      return @opts
    end

    def add_officious
    end
  end
end
