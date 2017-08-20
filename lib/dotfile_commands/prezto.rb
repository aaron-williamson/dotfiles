require 'dotfile_command_base'

module DotfilesCLI
  class Prezto < DotfileCommandBase
    desc 'Link prezto configuration files'

    def setup(*_args)
      prezto_dir         = File.join(options[:configs], 'zprezto')
      prezto_runcoms_dir = File.join(prezto_dir, 'runcoms')

      create_link File.join(options[:destination], '.zprezto'), prezto_dir

      %w[
        zlogin
        zlogout
        zpreztorc
        zprofile
        zshenv
        zshrc
      ].each do |file|
        create_link File.join(options[:destination], ".#{file}"), File.join(prezto_runcoms_dir, file)
      end
    end
  end
end
