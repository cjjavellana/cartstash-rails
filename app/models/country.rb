class Country < ActiveRecord::Base

  def self.get_countries
    countries = RedisClient.get("countries")
    if countries.nil?
      countries = Country.all.to_json
      # decline caching if list is empty
      RedisClient.set("countries", countries) unless countries.equal? "[]"
    end

    JSON.parse(countries)
  end
end
