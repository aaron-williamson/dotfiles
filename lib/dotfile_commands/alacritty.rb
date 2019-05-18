require 'dotfile_command_base'

module DotfilesCli
  module DotfileCommands
    class Alacritty < DotfileCommandBase
      desc '', 'Link alacritty configuration file'

      def setup(*_args)
        config = config_home
        conf_name = 'alacritty.yml'
        create_link File.join(config, 'alacritty', conf_name), File.join(options[:configs], conf_name)
      end
    end
  end
end
