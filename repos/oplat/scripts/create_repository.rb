#!/usr/bin/env ruby

require 'mysql2'

if ARGV.size < 4
  $stderr.puts "#{$0} user repository password net"
  exit 1
end

user = ARGV[0]
repository = ARGV[1]
db_password = ARGV[2]
db_net = ARGV[3]
user_repos = c.escape("#{user}_#{repository}")


# `/home/gitadmin/gitolite-admin`


## DATABASE
c = Mysql2::Client.new(:host => ENV['OPLAT_EXT_DATABASE_HOST'],
                       :username => ENV['OPLAT_EXT_DATABASE_USER'],
                       :password => ENV['OPLAT_EXT_DATABASE_PASSWORD'],
                       :databsae => "mysql")

c.query("set character set utf8")
c.query("grant all privileges on `#{user_repos}`.* to '#{user_repos}'@'#{db_net}' identified by '#{db_password}'")
c.close

exit 0
