class CreditCardType < ActiveRecord::Base

  def self.get_credit_card_types
    types = RedisClient.get 'cc_types'

    if types.nil?
      types = CreditCardType.all.to_json

      begin
        RedisClient.set('cc_types', types) unless types.equal? []
      rescue
        # Do nothing when redis is unavailable
      end
    end

    JSON.parse(types)
  end

end
