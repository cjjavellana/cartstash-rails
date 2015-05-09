FactoryGirl.define do
  factory :us, class: Country do
    country_code  "US"
    name          "United States"
    short_name    "United States"
  end

  factory :gb, class: Country do
    country_code  "GB"
    name          "Great Britain"
    short_name    "Great Britain"
  end

  factory :ph, class: Country do
    country_code  "PH"
    name          "Philippines"
    short_name    "Philippines"
  end

  factory :sg, class: Country do
    country_code  "SG"
    name          "Singapore"
    short_name    "Singapore" 
  end

  factory :my, class: Country do
    country_code  "MY"
    name          "Malaysia"
    short_name    "Malaysia"
  end
end