module Constants

  module Tax
    RATE = 0.12
  end

  module Currency
    USD = 'USD'
    PHP = 'PHP'
  end

  module Membership
    FEE_DEFAULT = 888.88

    # Membership status
    PENDING = 'pending'
    ACTIVE = 'active'
    EXPIRED = 'expired'
    CANCELLED = 'cancelled'
    DELETED = 'deleted'
  end

  module SequenceGenerator
    MEMBERSHIP = 'membership'
    PAYMENT = 'payment'
  end

  module PaymentMethod
    ACTIVE = 'active'
    DELETED = 'deleted'
    EXPIRED = 'expired'
  end

  module AddressStatus
    ACTIVE = 'active'
    DELETED = 'deleted'
  end

  module PaymentType
    CREDIT_CARD = "credit_card"
    CASH_ON_DELIVERY = "cod"
  end

  module SalesOrderStatus
    ORDER_RECEIVED = "received"
    PENDING_PACKING = "pending_packing"
    PACKING = "packing"
    DISPATCHED = "dispatched"
    CUSTOMER_RECEIVED = "customer_recieved"
    RETURNED = "returned"
    CANCELLED = "cancelled"
  end
end