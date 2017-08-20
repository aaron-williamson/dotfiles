require_relative 'dotfile'

module DotfilesCLI
  class Inputrc < Dotfile
    desc 'setup', 'link inputrc file'
    def setup(*_args)
      create_link File.join(options[:destination], '.inputrc'), File.join(options[:configs], 'inputrc')
    end
  end
end
