json.array!(@hosts) do |host|
  json.extract! host, :id, :name, :ipaddr
  json.url host_url(host, format: :json)
end
