require 'utils'
require 'thor/group'

module DotfilesCLI
  class DotfileCommandBase < Thor::Group
    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    end

    include Thor::Actions
    include DotfilesCLI::Utils

    add_runtime_options!
  end
end
