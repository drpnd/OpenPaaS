#!/usr/bin/env ruby

require 'mysql2'
require 'fileutils'
require 'shellwords'

if ARGV.size < 2
  $stderr.puts "#{$0} user repository password net"
  exit 1
end

username = ARGV[0]
repository = ARGV[1]

# Check the argument
if username.empty?
  $stderr.puts "Empty username"
  exit 1
end

lockfile = '/tmp/oplat.lock'

# Working directory
wd = ENV['OPLAT_GITOLITE_REPOSITORY']
ENV['HOME'] = ENV['OPLAT_GITOLITE_HOME']

FileUtils.cd(wd)

if File.exist?(lockfile)
  $stderr.puts "File is locked"
  exit 1
end

# Lock
FileUtils.touch(lockfile)

rd = ENV['OPLAT_GIT_REPOSITORIES']

cd = File.dirname(__FILE__)

str = "#!/bin/sh
## Username/Repository
REPOSITORY=\"#{username}/#{repository}\"
"
str0 = File.read("#{cd}/rails_git_post_update_hook.sh")

File.write("#{rd}/#{username}/#{repository}.git/hooks/post-update", str + str0)

system("chmod +x #{rd}/#{username}/#{repository}.git/hooks/post-update")
system("chown git #{rd}/#{username}/#{repository}.git/hooks/post-update")

# Unlock
FileUtils.rm(lockfile)

exit 0