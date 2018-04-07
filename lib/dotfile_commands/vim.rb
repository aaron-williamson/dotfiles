require 'dotfile_command_base'

module DotfilesCli
  module DotfileCommands
    class Vim < DotfileCommandBase
      desc '', 'Link vim/neovim config directories'

      def setup(*_args)
        if executable_in_path?('nvim')
          config = config_home
          create_link File.join(config, 'nvim'), File.join(options[:configs], 'vim')
        end

        # rubocop:disable GuardClause
        if executable_in_path?('vim')
          create_link File.join(options[:destination], '.vim'), File.join(options[:configs], 'vim')
        end
        # rubocop:enable GuardClause
      end
    end
  end
end
