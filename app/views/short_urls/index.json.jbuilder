json.urls do
  json.array! @urls, :short_code, :title, :click_count, :full_url
end