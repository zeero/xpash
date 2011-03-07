require 'xpash/cmd/cd'
require 'xpash/cmd/ls'
require 'xpash/cmd/grep'
require 'xpash/cmd/help'

module XPash
  class Base
    def up(*args)
    end

    def exit(*args)
      Kernel.exit
    end
    alias :quit :exit
  end
end
