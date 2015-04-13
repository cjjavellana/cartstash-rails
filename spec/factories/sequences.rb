FactoryGirl.define do

  factory :membership_sequence, class: Sequence do
    name  'membership'
    value 1
  end

  factory :payment_sequence, class: Sequence do
    name  'payment'
    value 1
  end
end