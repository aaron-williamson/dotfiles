require 'open3'

module DotfilesCLI
  module Utils
    def executable_in_path?(name)
      _, status = Open3.capture2('command', '-v', name)
      status.exitstatus.zero?
    end
  end
end
