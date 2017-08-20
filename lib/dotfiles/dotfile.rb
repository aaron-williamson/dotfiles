# This class isn't actually used for anything, it's just boiler plate that gets extended by other dotfiles
module DotfilesCLI
  class Dotfile < Thor
    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    end

    include Thor::Actions
    add_runtime_options!
    default_task :setup

    desc 'setup', 'example setup'
    def setup(*_args); end
  end
end
