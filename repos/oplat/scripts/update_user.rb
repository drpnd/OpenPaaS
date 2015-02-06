#!/usr/bin/env ruby

require 'fileutils'
require 'shellwords'

if ARGV.size < 2
  $stderr.puts "#{$0} username ssh-key"
  exit 1
end

username = ARGV[0]
sshpubkey = ARGV[1]
lockfile = '/tmp/oplat.lock'

# Check the argument
if username.empty?
  $stderr.puts "Empty username"
  exit 1
end

# Working directory
wd = ENV['OPLAT_OPLAT_GITOLITE_REPOSITORY']
ENV['HOME'] = ENV['OPLAT_OPLAT_GITOLITE_HOME']

FileUtils.cd(wd)

if File.exist?(lockfile)
  $stderr.puts "File is locked"
  exit 1
end

# Lock
FileUtils.touch(lockfile)

unless File.exist?("keydir/#{username}.pub")
  $stderr.puts "User not found"
  FileUtils.rm(lockfile)
  exit 1
end
begin
  file = File.open("keydir/#{username}.pub", 'w')
  file.write(sshpubkey)
rescue IOError => e
ensure
  file.close unless file == nil
end
#File.write("keydir/#{username}.pub", sshpubkey)
system("git commit -m \"update #{username.shellescape}.\" keydir/#{username.shellescape}.pub")
r = system("git push")

# Unlock
FileUtils.rm(lockfile)

if r
  exit 0
else
  exit 1
end
