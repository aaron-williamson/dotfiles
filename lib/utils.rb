require 'open3'

module DotfilesCli
  module Utils
    def executable_in_path?(name)
      _, status = Open3.capture2('which', name)
      status.exitstatus.zero?
    end

    def config_home
      # Get the config_home and make sure it exists
      config = ENV['XDG_CONFIG_HOME'] || File.join(options[:destination], '.config')
      empty_directory config
      config
    end
  end
end
