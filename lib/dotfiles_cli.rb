require 'thor'

# Require each dotfile specification
DOTFILE_COMMAND_FILES = Dir.glob(File.expand_path('dotfile_commands/*', __dir__))
DOTFILE_COMMAND_FILES.each do |file|
  require file.gsub(/\.rb$/, '')
end

module DotfilesCli
  class Dotfiles < Thor
    # rubocop:disable LineLength
    class_option :destination,  desc: 'Where to link dotfiles/render dotfile templates', default: Dir.home
    class_option :configs,      desc: 'Where to look for dotfiles to link',              default: File.expand_path('../configs', File.dirname(__FILE__))
    class_option :templates,    desc: 'Where to look for dotfile templates to render',   default: File.expand_path('../templates', File.dirname(__FILE__))
    # rubocop:enable LineLength

    desc 'all', 'run all dotfile configurations'
    method_option :exclude, aliases: '-e', default: [], desc: 'A list of configurations to exclude from this run'

    def all(*_args)
      Dotfiles.subcommands.reject { |sc| options[:exclude].include?(sc) }.each do |cmd|
        invoke cmd, args
      end
    end

    # Add the different dotfile subcommands
    dotfile_objs = DOTFILE_COMMAND_FILES.map do |f|
      basename = File.basename(f.gsub(/\.rb$/, ''))
      const    = basename.split('_').collect(&:capitalize).join
      DotfilesCli::DotfileCommands.const_get(const)
    end

    dotfile_objs.each do |klass|
      name = klass.to_s.downcase.gsub(/^.*::/, '')
      desc name, "Run #{name} dotfile configuration"
      subcommand name, klass
    end

    default_task :all
  end
end
