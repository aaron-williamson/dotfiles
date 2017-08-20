require_relative 'dotfile'

module DotfilesCLI
  class Ag < Dotfile
    desc 'setup', 'Link agignore file'
    def setup(*_args)
      create_link File.join(options[:destination], '.agignore'), File.join(options[:configs], 'agignore')
    end
  end
end
