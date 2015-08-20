json.array!(@users) do |user|
  json.extract! user, :id, :–skip
  json.url user_url(user, format: :json)
end
