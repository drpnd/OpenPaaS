#!/usr/bin/env ruby

require 'fileutils'
require 'shellwords'

if ARGV.size < 1
  $stderr.puts "#{$0} username"
  exit 1
end

username = ARGV[0]
lockfile = '/tmp/oplat.lock'

# Check the argument
if username.empty?
  $stderr.puts "Empty username"
  exit 1
end

# Working directory
wd = ENV['OPLAT_OPLAT_GITOLITE_REPOSITORY']

unless File.exist?(lockfile)
  $stderr.puts "File is locked"
  exit 1
end

# Lock
FileUtils.touch(lockfile)

FileUtils.cd(wd)

if File.exist?("keydir/#{username}.pub")
  $stderr.puts "User already exists"
  exit 1
end
FileUtils.touch("keydir/#{username}.pub")
`git add keydir/#{username.shellescape}.pub`
`git commit -m "add #{username.shellescape}" keydir/#{username.shellescape}.pub`
`git push`

# Unlock
FileUtils.rm(lockfile)
