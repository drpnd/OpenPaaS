#!/usr/bin/env ruby

require 'mysql2'
require 'fileutils'
require 'shellwords'

if ARGV.size < 4
  $stderr.puts "#{$0} user repository password net"
  exit 1
end

username = ARGV[0]
repository = ARGV[1]
db_password = ARGV[2]
db_net = ARGV[3]
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

#
rd = ENV['OPLAT_GIT_REPOSITORY']
admin = ENV['OPLAT_GITOLITE_USER']

# New configuration
str = File.read("#{wd}/conf/gitolite.conf")
str = str + "
repo    #{username}/#{repository}
        RW+     =   #{admin}
        RW      =   #{username}
        R       =   ins"
File.write("#{wd}/conf/gitolite.conf", str)

system("git commit -m \"update.\" -a")
system("git push")


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


## DATABASE
c = Mysql2::Client.new(:host => ENV['OPLAT_EXT_DATABASE_HOST'],
                       :username => ENV['OPLAT_EXT_DATABASE_USER'],
                       :password => ENV['OPLAT_EXT_DATABASE_PASSWORD'],
                       :databsae => "mysql")

c.query("set character set utf8")
c.query("create database `#{user_repos}` default charset utf8 collate utf8_general_ci")
c.query("grant all privileges on `#{user_repos}`.* to '#{user_repos}'@'#{db_net}' identified by '#{db_password}'")
c.close

exit 0
