json.array!(@instances) do |instance|
  json.extract! instance, :id, :name, :ipaddr, :repository_id, :host_id
  json.url instance_url(instance, format: :json)
end
