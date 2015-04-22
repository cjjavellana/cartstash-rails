FactoryGirl.define do

  factory :foobar_visa, class: PaymentMethod do
    first_name        "Foobar"
    last_name         "Kadigan"
    credit_card_type  "visa"
    credit_card_no    "4539016690974009"
    security_code     "587"
    expiry_month      "10"
    expiry_year       "2017"
    address_line1     "#123-456 Make Believe Blvd"
    city              "Iloilo"
    zip_code          "5000"
    country           "PH"
    status            Constants::PaymentMethod::ACTIVE

    association :user, factory: :user, strategy: :build
  end

end