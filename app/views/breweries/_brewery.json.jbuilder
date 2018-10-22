json.extract! brewery, :id, :name, :year, :active
json.beers do
  json.names brewery.beers.map(&:name)
end
json.url brewery_url(brewery, format: :json)
