require 'rails_helper'

RSpec.describe SchedulePickerController, type: :controller do

  describe "get" do

    it "returns an error when parameter date is less than current date" do
      expected_response = {error: "Date cannot be less than current date"}.to_json

      get :available_time, :date => (Date.today - 1).strftime('%Y-%m-%d')
      expect(response.body).to eq(expected_response)
    end

    it "returns an error when parameter date is beyond 2 weeks from current date" do
      expected_response = {error: "Unable to schedule delivery two weeks in advance"}.to_json

      get :available_time, :date => (Date.today + 2.weeks).strftime('%Y-%m-%d')
      expect(response.body).to eq(expected_response)
    end

    it "returns the available delivery slots for the current date" do
      expected_response = {
        timeslot: [
          {starttime: "18:00", endtime: "20:00"},
          {starttime: "20:00", endtime: "22:00"}
        ]
      }.to_json

      expect(DateTime).to receive(:now).at_least(:once).and_return(DateTime.now.change({hour: 16, min: 0, sec: 0}))
      get :available_time, :date => Date.today.strftime('%Y-%m-%d')
      expect(response.body).to eq(expected_response)
    end

    it "returns timeslots from 8am to 10pm" do
      expected_response = {
        timeslot: [
          {starttime: "08:00", endtime: "10:00"},
          {starttime: "10:00", endtime: "12:00"},
          {starttime: "12:00", endtime: "14:00"},
          {starttime: "14:00", endtime: "16:00"},
          {starttime: "16:00", endtime: "18:00"},
          {starttime: "18:00", endtime: "20:00"},
          {starttime: "20:00", endtime: "22:00"}
        ]
      }.to_json

      get :available_time, :date => (Date.today + 1.day).strftime('%Y-%m-%d')
      expect(response.body).to eq(expected_response)
    end
  end

end
