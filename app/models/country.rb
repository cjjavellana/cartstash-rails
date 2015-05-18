class Country < ActiveRecord::Base

  def self.get_countries
    countries = RedisClient.get("countries")
    if countries.nil?
      countries = Country.all.to_json

      begin
        RedisClient.set("countries", countries) unless countries.equal? "[]"
      rescue
        # Do nothing when redis is unavailable
      end
    end

    JSON.parse(countries)
  end
end
