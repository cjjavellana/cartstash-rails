FactoryGirl.define do

  factory :user do
    id          1
    first_name  'Foobar'
    last_name   'Kadigan'
    email       'foobar@kadigan.com'
    password    'password'
  end
end