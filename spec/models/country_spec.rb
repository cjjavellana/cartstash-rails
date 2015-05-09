require 'rails_helper'

describe Country do
  
  let(:countries) {
    [
      build_stubbed(:us),
      build_stubbed(:gb),
      build_stubbed(:ph),
      build_stubbed(:sg),
      build_stubbed(:my)
    ]
  }

  context "Get countries" do

    it "returns the list of countries from redis cache" do
      expect(RedisClient).to receive(:get).with("countries").and_return(countries.to_json)
      list = Country.get_countries
      expect(list).to_not be_nil
    end

    it "queries the database when redis is not available" do
      expect(RedisClient).to receive(:get).with("countries").and_return(nil)
      expect(Country).to receive(:all).and_return(countries)
      expect(RedisClient).to receive(:set).and_return(nil)
      list = Country.get_countries
      expect(list).to_not be_nil
    end
  end

end