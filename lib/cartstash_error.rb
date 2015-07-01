module CartstashError
  class Error < RuntimeError; end
  class PaymentError < Error; end
  class CartError < Error; end
end