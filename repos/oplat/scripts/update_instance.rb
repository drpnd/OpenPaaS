require "#{File.dirname(__FILE__)}/../config/environment.rb"

repos = ENV['REPOSITORY']
(user_name, repository_name) = repos.split(/\//)

user = User.find_by(name: user_name)
unless user
  exit 1
end

repository = Repository.find_by(name: repository_name, user_id: user.id)
unless repository
  exit 1
end

addrs = ""
Instance.where(repository_id: repository.id).find_each do |instance|
  instance.repository_id = nil

  host = Host.find_by(instance.host_id)

  ## Start the instance
  cmd = "ssh -o StrictHostKeyChecking=no oplat@#{host.ipaddr.shellescape} " +
    "sudo lxc-start -n #{instance.name.shellescape} -d"
  system( cmd )

  cmd = "ssh -o StrictHostKeyChecking=no oplat@#{instance.ipaddr.shellescape} " +
    "./OpenPaaS/instances/rails_deploy.sh " +
    "\"#{ENV['RAILS_ENV'].shellescape}\" " +
    "\"#{repository.db_password.shellescape}\" " +
    "\"#{ENV['OPLAT_REPOSITORY_SERVER'].shellescape}\" " +
    "\"#{user.name.shellescape}\" " +
    "\"#{repository.name.shellescape}\" " +
    "\"#{ENV['OPLAT_USER_DATABASE_URL'].shellescape}\""
  system( cmd )

  cmd = "ssh -f -n -o StrictHostKeyChecking=no oplat@#{instance.ipaddr.shellescape} " +
    "./OpenPaaS/instances/rails_instance.sh " +
    "\"#{ENV['RAILS_ENV'].shellescape}\" " +
    "\"#{repository.db_password.shellescape}\" " +
    "\"#{repository.secret_token.shellescape}\" " +
    "\"#{repository.name.shellescape}\" " +
    "\"#{ENV['OPLAT_USER_DATABASE_URL'].shellescape}\" > /dev/null 2>&1"
  system( cmd )
  # job1 = fork do
  #   exec cmd
  # end
  # Process.detach(job1)

  addrs += " #{instance.ipaddr.shellescape}"
end

cmd = "ssh -f -n -o StrictHostKeyChecking=no oplat@#{ENV['OPLAT_HTTP_LB']} " +
  "sudo /opt/nginx_autoconfig.sh #{repository.name.shellescape}.#{user.name.shellescape}.#{ENV['OPLAT_HTTP_LB_SUFFIX']} #{addrs} > /dev/null 2>&1"
system( cmd )

exit 0
