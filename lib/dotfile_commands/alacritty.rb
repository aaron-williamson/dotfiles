require 'dotfile_command_base'

module DotfilesCli
  module DotfileCommands
    class Alacritty < DotfileCommandBase
      desc '', 'Link alacritty configuration files'

      def setup(*_args)
        config = config_home
        create_link File.join(config, 'alacritty', 'alacritty.yml'), File.join(options[:configs], 'alacritty.yml')
      end
    end
  end
end
