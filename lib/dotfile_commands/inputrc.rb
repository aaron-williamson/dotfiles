require 'dotfile_command_base'

module DotfilesCli
  module DotfileCommands
    class Inputrc < DotfileCommandBase
      desc '', 'Link inputrc file'

      def setup(*_args)
        create_link File.join(options[:destination], '.inputrc'), File.join(options[:configs], 'inputrc')
      end
    end
  end
end
