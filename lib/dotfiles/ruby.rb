require_relative 'dotfile'

module DotfilesCLI
  class Ruby < Dotfile
    desc 'setup', 'link ruby configuration files'
    def setup(*_args)
      create_link File.join(options[:destination], '.irbrc'), File.join(options[:configs], 'irbrc')
      create_link File.join(options[:destination], '.gemrc'), File.join(options[:configs], 'gemrc')
    end
  end
end
