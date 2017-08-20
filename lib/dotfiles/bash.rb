require_relative 'dotfile'

module DotfilesCLI
  class Bash < Dotfile
    desc 'setup', 'link bash configuration files'
    def setup(*_args)
      create_link File.join(options[:destination], '.bashrc'), File.join(options[:configs], 'bashrc')
      create_link File.join(options[:destination], '.bash_profile'), File.join(options[:configs], 'bash_profile')
    end
  end
end
