require 'open3'

module DotfilesCli
  module Utils
    def executable_in_path?(name)
      _, status = Open3.capture2('which', name)
      status.exitstatus.zero?
    end
  end
end
