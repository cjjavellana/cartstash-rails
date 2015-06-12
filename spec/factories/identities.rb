FactoryGirl.define do
  factory :identity do
    user :user
    provider "facebook"
    uid "1001"
  end

end
