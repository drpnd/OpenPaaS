class Instance < ActiveRecord::Base
  belongs_to :host
  belongs_to :repository
end
