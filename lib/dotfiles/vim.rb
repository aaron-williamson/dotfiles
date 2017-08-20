require_relative 'dotfile'
require 'mkmf'

module DotfilesCLI
  class Vim < Dotfile
    desc 'setup', 'link vim/neovim config directories'
    def setup(*_args)
      unless find_executable('nvim').nil?
        config = ENV['XDG_CONFIG_HOME'] || File.join(options[:destination], '.config')
        empty_directory config
        create_link File.join(config, 'nvim'), File.join(options[:configs], 'vim')
      end

      # rubocop:disable GuardClause
      unless find_executable('vim').nil?
        create_link File.join(options[:destination], '.vim'), File.join(options[:configs], 'vim')
      end
      # rubocop:enable GuardClause
    end
  end
end
