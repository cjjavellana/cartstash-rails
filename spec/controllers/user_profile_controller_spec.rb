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
      expect(object_twin).to receive(:assign_attributes).with({first_name: "Foobarbaz"})
      expect(User).to receive(:find).and_return(object_twin)

      put :update, id: "", user: {first_name: "Foobarbaz"}
    end

    it "allows the user to change the password" do
      user = build_stubbed(:user)
      expect(user).to receive(:update_with_password)
      expect(User).to receive(:find).and_return(user)

      patch :update_password,  { format: 'js',
                                 user: { password: 'pass1234',
                                         confirm_password: 'pass1234' ,
                                         current_password: 'old_password' }}
    end
  end

end
