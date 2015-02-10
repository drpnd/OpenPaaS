require "#{File.dirname(__FILE__)}/../../config/environment.rb"


p FileUtils

#cmd = "ssh $HTTP_LB sudo /opt/nginx_autoconfig.sh $fqdn $arg"
system( cmd )
