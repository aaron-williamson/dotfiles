require 'thor'

# Require each dotfile specification
DOTFILE_COMMAND_FILES = Dir.glob(File.expand_path('../dotfile_commands/*', __FILE__))
DOTFILE_COMMAND_FILES.each do |file|
  require file.gsub(/\.rb$/, '')
end

module DotfilesCLI
  class Dotfiles < Thor
    class_option :destination, default: Dir.home
    class_option :configs,     default: File.expand_path('../configs', File.dirname(__FILE__))
    class_option :templates,   default: File.expand_path('../templates', File.dirname(__FILE__))

    desc 'all', 'run all dotfile configurations'
    method_option :exclude, aliases: :e, default: []
    def all(*_args)
      puts options.inspect
      puts 'Under construction'
      # Dotfiles.subcommands.reject { |sc| options[:exclude].include?(sc) }.each do |cmd|
      #   invoke cmd, args
      # end
    end

    DOTFILE_COMMAND_FILES.map do |f|
      basename = File.basename(f.gsub(/\.rb$/, ''))
      const    = basename.split('_').collect(&:capitalize).join
      Object.const_get("DotfilesCLI::#{const}")
    end.each do |klass|
      name = klass.to_s.downcase.gsub(/^.*::/, '')
      register(klass, name, name, "Configure #{name} dotfile(s)")
    end

    default_task :all
  end
end
