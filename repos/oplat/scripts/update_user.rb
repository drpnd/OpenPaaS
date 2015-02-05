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

if File.exist?(lockfile)
  $stderr.puts "File is locked"
  exit 1
end

# Lock
FileUtils.touch(lockfile)

FileUtils.cd(wd)

unless File.exist?("keydir/#{username}.pub")
  $stderr.puts "User not found"
  exit 1
end
ile.write("keydir/#{username}.pub", sshpubkey)
`git commit -m "update #{username.shellescape}" keydir/#{username.shellescape}.pub`
`git push`

# Unlock
FileUtils.rm(lockfile)
