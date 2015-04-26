require 'rails_helper'

RSpec.describe SchedulePickerController, type: :controller do

  describe "get" do
    it "retrieves the current date and time from the server" do
      xhr :get, :current_datetime
      expect(response).to have_http_status(:success)
    end

  end

end