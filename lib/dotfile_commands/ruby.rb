require 'dotfile_command_base'

module DotfilesCli
  module DotfileCommands
    class Ruby < DotfileCommandBase
      desc '', 'Link ruby configuration files'

      def setup(*_args)
        create_link File.join(options[:destination], '.irbrc'), File.join(options[:configs], 'irbrc')
        create_link File.join(options[:destination], '.gemrc'), File.join(options[:configs], 'gemrc')
      end
    end
  end
end
