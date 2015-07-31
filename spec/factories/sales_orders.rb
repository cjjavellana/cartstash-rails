FactoryGirl.define do
  factory :sales_order do
    order_date              DateTime.current
    order_amount            BigDecimal.new 1000.00, 2
    payment_type            Constants::PaymentType::CASH_ON_DELIVERY
    transaction_ref         "abcdefghij"
    payment_method          nil
    delivery_date           1.day.from_now
    time_range              "8:00-10:00"
    received_date           nil
    order_dispatched_date   nil
    remarks                 nil
    status                  Constants::SalesOrderStatus::ORDER_RECEIVED

    association :delivery_address, factory: :foobar_delivery_address, strategy: :build
    association :user, factory: :user, strategy: :build
  end

  factory :sales_order_cc, class: SalesOrder do
    order_date              DateTime.current
    order_amount            nil
    payment_type            Constants::PaymentType::CREDIT_CARD
    transaction_ref         "defabctry"
    delivery_date           1.day.from_now
    time_range              "8:00-10:00"
    received_date           nil
    order_dispatched_date   nil
    remarks                 nil
    status                  Constants::SalesOrderStatus::ORDER_RECEIVED

    association :delivery_address, factory: :foobar_delivery_address, strategy: :build
    association :user, factory: :user, strategy: :build
    association :payment_method, factory: :foobar_visa, strategy: :build
  end

end
