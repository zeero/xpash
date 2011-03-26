require 'optparse'

require 'xpash/frame'

module XPash
  class CLI

    def self.start(argv)

      # parse ARGV
      opts = optparse!(argv)

      # check options
      unless opts[:filepath]
        puts "file path?"
        filepath = $stdin.gets
        puts
      end
      if File::ALT_SEPARATOR
        filepath = opts[:filepath].gsub(File::ALT_SEPARATOR, File::SEPARATOR)
      else
        filepath = opts[:filepath]
      end

      # initialize main class
      xpash = XPash::Base.new(filepath, opts)

      if opts[:query]
        xpash.cd(opts[:query])
        xpash.ls
        exit
      end

      # main loop
      Signal.trap(:INT, nil)
      loop do
        XPash::Frame.display(xpash)
      end

    end

    def self.optparse!(argv)

      opts = {
        # TODO: development setting
        :filepath => "#{File.dirname(__FILE__)}/../../spec/fixture/default.html",
        :color => true
      }
      mandatory_opts = %w(  )

      OptionParser.new(nil, 24) do |o|
        o.banner = <<-BANNER.gsub(/^          /,'')
          Usage: #{File.basename($0)} [options]

        BANNER
        o.program_name = XPash.name
        o.version = XPash::VERSION

        o.separator "Options are:"
        o.on("-f", "--file PATH",
                "Specify file path.",
                "Default, display prompt to input file path."){|path|
          opts[:filepath] = path
        }
        o.on("-q", "--query \'XPATH\'",
                "XPATH should be fasten with \"\'\".",
                "When using this option with \'-f\' option,",
                "display matched data and exit.",
                "Without \'-f\' option, \'XPATH\' is used for",
                "default path in XPash command line."){|query|
          opts[:query] = query
        }
        o.on("-v", "--version",
                "Show version.") {puts o.ver; exit}
        o.on("-h", "--help",
                "Show this help message.") {puts o.help; exit}

        o.parse!(argv)

        if mandatory_opts && mandatory_opts.find { |opt| opts[opt.to_sym].nil? }
          puts "Error: option [#{mandatory_opts.join(", ")}] are required."
          puts o.banner; exit
        end
      end

      return opts

    end
  end
end
