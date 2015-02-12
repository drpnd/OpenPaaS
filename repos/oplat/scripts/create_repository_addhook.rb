#!/usr/bin/env ruby

require 'mysql2'
require 'fileutils'
require 'shellwords'

if ARGV.size < 3
  $stderr.puts "#{$0} user repository password net"
  exit 1
end

username = ARGV[0]
repository = ARGV[1]
db_password = ARGV[2]
user_repos = Shellwords.escape("#{username}_#{repository}")

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
REPOSITORY_SERVER=\"#{ENV['OPLAT_REPOSITORY_SERVER']}\"

RAILS_ENV=\"production\"
OPLAT_REPOSITORY_SERVER=\"#{ENV['OPLAT_REPOSITORY_SERVER'].shellescape}\"
OPLAT_GITOLITE_USER=\"#{ENV['OPLAT_GITOLITE_USER'].shellescape}\"
OPLAT_GITOLITE_HOME=\"#{ENV['OPLAT_GITOLITE_HOME'].shellescape}\"
OPLAT_GITOLITE_REPOSITORY=\"#{ENV['OPLAT_GITOLITE_REPOSITORY'].shellescape}\"
OPLAT_GIT_REPOSITORIES=\"#{ENV['OPLAT_GIT_REPOSITORIES'].shellescape}\"
OPLAT_USER_DATABASE_URL=\"mysql2://#{user_repos.shellescape}:#{URI.escape(db_password, "/").shellescape}@#{ENV['OPLAT_EXT_DATABASE_HOST'].shellescape}/#{user_repos.shellescape}\"

"
str0 = File.read("#{cd}/rails_git_post_update_hook.sh")

File.open("#{rd}/#{username}/#{repository}.git/hooks/post-update", 'w') {
  |file| file.write(str + str0)
}

system("chmod +x #{rd}/#{username}/#{repository}.git/hooks/post-update")
system("chown git #{rd}/#{username}/#{repository}.git/hooks/post-update")

# Unlock
FileUtils.rm(lockfile)

exit 0
