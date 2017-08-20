require_relative 'dotfile'
require 'open3'

module DotfilesCLI
  class Git < Dotfile
    desc 'setup', 'generate gitconfig from template'
    class_option 'git-user'
    class_option 'git-email'
    class_option 'git-push'
    def setup(*_args)
      return if find_executable('git').nil?

      dest_config = File.join(options[:destination], '.gitconfig')
      fancy_diff  = !find_executable('diff-so-fancy').nil?
      user  = options['git-user']
      email = options['git-email']

      # Attempt to determine user and/or email from existing config
      if File.exist?(dest_config) && (user.nil? || email.nil?)
        contents = File.read(dest_config)

        user  = contents.match(/^\tname\s+=(.*)$/) { |m| m[1].strip } if user.nil?
        email = contents.match(/^\temail\s+=(.*)$/) { |m| m[1].strip } if email.nil?
      end

      # Don't create a config without user and email
      if user.nil? || email.nil?
        say 'ERROR (Git): could not determine gitconfig email and/or user', :red
        raise Thor::MissingArgumentError
      end

      # Determine git version
      git_version = Gem::Version.new(Open3.capture2('git --version').first.split("\s").last)

      push = options['git-push']

      if git_version >= Gem::Version.new('2.1.8')
        push = 'upstream' if push.nil?
        diff = 'patience'
      end

      submodule = if git_version >= Gem::Version.new('2.11.0')
                    'diff'
                  else
                    'log'
                  end

      template(File.join(options[:templates], 'gitconfig.erb'),
               dest_config,
               submodule: submodule,
               diff: diff,
               push: push,
               user: user,
               email: email,
               fancy_diff: fancy_diff)
    end
  end
end
