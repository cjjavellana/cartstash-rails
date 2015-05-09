FactoryGirl.define do

  factory :user do
    id          1
    first_name  'Foobar'
    last_name   'Kadigan'
    email       'foobar@kadigan.com'
    password    'password'
  end

  factory :unregistered, class: User do
    first_name  'Foo'
    last_name   'Bar'
    email       'foo@bar.com'
    password    'password'
  end

end