require 'dotfile_command_base'

module DotfilesCli
  module DotfileCommands
    class Kitty < DotfileCommandBase
      desc '', 'Link kitty terminal configuration file'

      def setup(*_args)
        config = config_home
        conf_name = 'kitty.conf'
        create_link File.join(config, 'kitty', conf_name), File.join(options[:configs], conf_name)
      end
    end
  end
end
