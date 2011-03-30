require 'xpash/cmd/cd'
require 'xpash/cmd/dump'
require 'xpash/cmd/grep'
require 'xpash/cmd/help'
require 'xpash/cmd/ls'

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
