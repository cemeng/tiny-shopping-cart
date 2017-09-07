require 'shopping_cart'

RSpec.describe ShoppingCart do
  let(:shopping_cart) { ShoppingCart.new(MobilePhonePricingRule) }

  describe '#add' do
    it 'adds an item shopping cart' do
      small_plan = MobilePhonePricingRule.find_by_product_code('ult_small')
      expect { shopping_cart.add(small_plan) }.to change { shopping_cart.items.count }.by(1)
    end
  end

  describe '#total' do
    context 'when no specials nor promos are applicable' do
      it 'sums the price of all items in the cart' do
        allow(MobilePhonePricingRule).to receive(:find_by_product_code).with('item_1').and_return({ price: 10 })
        allow(MobilePhonePricingRule).to receive(:find_by_product_code).with('item_2').and_return({ price: 10 })
        shopping_cart.add(MobilePhonePricingRule.find_by_product_code('item_1'))
        shopping_cart.add(MobilePhonePricingRule.find_by_product_code('item_2'))
        expect(shopping_cart.total).to eq 20
      end
    end
  end
end