require 'dotfile_command_base'

module DotfilesCLI
  class Ag < DotfileCommandBase
    desc 'Link agignore file'

    def setup(*_args)
      create_link File.join(options[:destination], '.agignore'), File.join(options[:configs], 'agignore')
    end
  end
end
