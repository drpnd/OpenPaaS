require "#{File.dirname(__FILE__)}/../../config/environment.rb"

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

Instance.where(repository_id: repository.id).find_each do |instance|
  instance.repository_id = nil
end

