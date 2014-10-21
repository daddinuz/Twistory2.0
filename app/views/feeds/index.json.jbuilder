json.array!(@feeds) do |feed|
  json.extract! feed, :id, :feed_text, :date, :has_been_published
  json.url feed_url(feed, format: :json)
end
