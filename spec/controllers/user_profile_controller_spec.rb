require 'rails_helper'

RSpec.describe UserProfileController, type: :controller do

  describe "user profile" do
    login_user

    it "displays the user's information" do
      expect(User).to receive(:find).and_return(build_stubbed(:user))
      get :index
      expect(assigns(:user).first_name).to eq("Foobar")
      expect(assigns(:user).last_name).to eq("Kadigan")
    end

    it "can update the user's first information" do
      object_twin = object_double(User.new)
      expect(object_twin).to receive(:valid?).and_return(true)
      expect(object_twin).to receive(:save)
      expect(object_twin).to receive(:assign_attributes).with({ first_name: "Foobarbaz" })
      expect(User).to receive(:find).and_return(object_twin)

      put :update, id: "", user: { first_name: "Foobarbaz" }
    end
  end

end
