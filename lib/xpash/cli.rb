require 'optparse'

require 'xpash/frame'

module XPash
  class CLI

    def self.start(argv=[])

      # parse ARGV
      opts = optparse(argv)

      # check options
      unless opts[:filepath]
        puts "file path?"
        filepath = gets
        puts
      end
      if File::ALT_SEPARATOR
        filepath = opts[:filepath].gsub(File::ALT_SEPARATOR, File::SEPARATOR)
      else
        filepath = opts[:filepath]
      end

      # initialize main class
      xpash = XPash::Base.new(filepath)

      if opts[:query]
        xpash.cd(opts[:query])
        xpash.ls
        exit
      end

      # main loop
      Signal.trap(:INT, nil)
      while true do
        XPash::Frame.display(xpash)
      end

    end

    def self.optparse(argv)

      # NOTE: the option -p/--path= is given as an example, and should be replaced in your application.

      options = {
        # TODO: development setting
        :filepath     => "#{File.dirname(__FILE__)}/../../work/test.html"
      }
      mandatory_options = %w(  )

      parser = OptionParser.new(nil, 24) do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')

          XPash is interactive interface for XPath.

          Usage: #{File.basename($0)} [options]

        BANNER
        opts.program_name = XPash.name
        opts.version = XPash::VERSION

        opts.separator "Options are:"
        opts.on("-f", "--file PATH",
                "Specify file path.",
                "Default, display prompt to input file path."){|path|
          options[:filepath] = path
        }
        opts.on("-q", "--query \'XPATH\'",
                "XPATH should be fasten with \"\'\".",
                "When using this option with \'-f\' option,",
                "display matched data and exit.",
                "Without \'-f\' option, \'XPATH\' is used for",
                "default path in XPash command line."){|query|
          options[:query] = query
        }
        opts.on("-v", "--version",
                "Show version.") {puts opts.ver; exit}
        opts.on("-h", "--help",
                "Show this help message.") {puts opts.help; exit}

        opts.parse!(argv)

        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
          puts "Error: option [#{mandatory_options.join(", ")}] are required."
          puts opts.banner; exit
        end
      end

      return options

    end
  end
end
