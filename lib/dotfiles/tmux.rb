require_relative 'dotfile'

module DotfilesCLI
  class Tmux < Dotfile
    desc 'setup', 'link tmux configuration file'
    def setup(*_args)
      create_link File.join(options[:destination], '.tmux.conf'), File.join(options[:configs], 'tmux.conf')
    end
  end
end
