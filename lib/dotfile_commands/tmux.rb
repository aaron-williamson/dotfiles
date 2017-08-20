require 'dotfile_command_base'

module DotfilesCLI
  class Tmux < DotfileCommandBase
    desc 'Link tmux configuration file'

    def setup(*_args)
      create_link File.join(options[:destination], '.tmux.conf'), File.join(options[:configs], 'tmux.conf')
    end
  end
end
