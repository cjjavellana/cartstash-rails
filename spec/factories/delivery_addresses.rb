FactoryGirl.define do
  factory :foobar_delivery_address, class: DeliveryAddress do
    recipient_name    "Foobar Kadigan"
    address_line_1    "#123-456 Make Believe Blvd"
    city              "Unknown City"
    zip_code          "5000"
    country           "Philippines"
    contact_no        "+63 916 700 7000"
    alternate_no      "+63 917 800 8000"
    status            "active"

    association :user, factory: :user, strategy: :build
  end

end
