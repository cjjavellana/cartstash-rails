require 'rails_helper'

describe DateHelper, type: :helper do
  include DateHelper

  it "formats a date to string" do
    date = Date.strptime("01-Jan-2015", "%d-%b-%Y")
    expect(date_to_string(date)).to eq("01/01/2015")
  end

end