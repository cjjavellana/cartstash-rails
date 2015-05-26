require 'rails_helper'

describe CreditCardType do

  context 'Get credit card types' do

    let(:credit_card_types) {
      [
          build_stubbed(:visa),
          build_stubbed(:master_card),
          build_stubbed(:amex),
      ]
    }

    it 'retrieves from redis when it is available in the cache' do
      expect(RedisClient).to receive('get').with('cc_types').and_return(credit_card_types.to_json)

      cc_types = CreditCardType.get_credit_card_types
      expect(cc_types.length).to eq(3)
    end

    it 'retrieves from database when data is not available in redis' do
      expect(RedisClient).to receive('get').with('cc_types').and_return(nil)
      expect(CreditCardType).to receive(:all).and_return(credit_card_types)

      cc_types = CreditCardType.get_credit_card_types
      expect(cc_types.length).to eq(3)
    end

  end

end

