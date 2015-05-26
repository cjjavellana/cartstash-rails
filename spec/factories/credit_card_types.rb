FactoryGirl.define do

  factory :visa, class: CreditCardType do
    name 'visa'
    description 'Visa'
  end

  factory :master_card, class: CreditCardType do
    name 'master_card'
    description 'Master Card'
  end

  factory :amex, class: CreditCardType do
    name 'amex'
    description 'American Express'
  end

end