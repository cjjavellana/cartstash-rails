FactoryGirl.define do
  factory :reserved_item do
    qty 9.99
    session_id "0123456789abcdef"

    association :user, factory: :user, strategy: :build
    association :product, factory: :breeze_detergent, strategy: :build
  end

end
