require 'xpash/cmd/cd'
require 'xpash/cmd/ls'
require 'xpash/cmd/grep'

module XPash
  class Base
    def up(args = nil)
    end

    def exit(args = nil)
      Kernel.exit
    end
    alias :quit :exit
  end
end
