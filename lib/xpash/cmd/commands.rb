require 'xpash/cmd/cd'
require 'xpash/cmd/ls'

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
