require 'thor'

# Require each dotfile specification
Dir.glob(File.join(File.dirname(__FILE__), 'dotfiles/*')).each do |file|
  require_relative file
end
EXCLUDE_CLASSES = %i[Dotfiles Dotfile].freeze

module DotfilesCLI
  class Dotfiles < Thor
    class_option :destination, default: Dir.home
    class_option :configs,     default: File.expand_path('../configs', File.dirname(__FILE__))
    class_option :templates,   default: File.expand_path('../templates', File.dirname(__FILE__))

    desc 'all', 'run all dotfile configurations'
    method_option :exclude, aliases: :e, default: []
    def all(*args)
      Dotfiles.subcommands.reject { |sc| options[:exclude].include?(sc) }.each do |cmd|
        invoke cmd, args
      end
    end

    DotfilesCLI.constants.reject { |cn| EXCLUDE_CLASSES.include?(cn) }.each do |const_name|
      name = const_name.downcase
      desc name, "Configure #{name} dotfile(s)"
      subcommand name, Object.const_get("DotfilesCLI::#{const_name}")
    end

    default_task :all
  end
end
