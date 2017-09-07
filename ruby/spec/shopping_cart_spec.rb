require 'shopping_cart'

RSpec.describe ShoppingCart do
  describe '#add' do
    let(:shopping_cart) { ShoppingCart.new(MobilePhonePricingRule) }

    it 'adds an item shopping cart' do
      small_plan = MobilePhonePricingRule.find_by_product_code('ult_small')
      expect { shopping_cart.add(small_plan) }.to change { shopping_cart.items.count }.by(1)
    end
  end
end
