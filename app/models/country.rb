class Country < ActiveRecord::Base

  def self.get_countries
    countries = RedisClient.get("countries")
    if countries.nil?
      countries = Country.all.to_json
      RedisClient.set("countries", countries)
    end

    countries = JSON.parse(countries)
  end
end
