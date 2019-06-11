require 'dotfile_command_base'

module DotfilesCli
  module DotfileCommands
    class Ruby < DotfileCommandBase
      desc '', 'Link ruby configuration files'

      def setup(*_args)
        create_link File.join(options[:destination], '.irbrc'), File.join(options[:configs], 'irbrc')
      end
    end
  end
end
