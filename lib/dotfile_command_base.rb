require 'utils'

module DotfilesCli
  class DotfileCommandBase < Thor
    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    end

    include Thor::Actions
    include DotfilesCli::Utils

    add_runtime_options!

    default_task :setup
  end
end
