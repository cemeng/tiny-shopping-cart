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
        allow(MobilePhonePricingRule).to receive(:find_by_product_code).with('ult_small').and_return({ price: 24.9 })
        allow(MobilePhonePricingRule).to receive(:find_by_product_code).with('ult_large').and_return({ price: 24.9 })
        shopping_cart.add(MobilePhonePricingRule.find_by_product_code('item_1'))
        shopping_cart.add(MobilePhonePricingRule.find_by_product_code('item_2'))
        expect(shopping_cart.total).to eq 20
      end
    end

    context 'when 3 for 2 deal for Unlimited 1GB special is activated' do
      it 'returns total with the discount applied' do
        unlimited_small = MobilePhonePricingRule.find_by_product_code('ult_small')
        3.times { shopping_cart.add(unlimited_small) }
        expect(shopping_cart.total).to eq (unlimited_small[:price] * 2)
      end
    end

    context 'when more than 3 5GB sims are added the price of each will drop to 39.90' do
      it 'returns total with the discount applied' do
        unlimited_large = MobilePhonePricingRule.find_by_product_code('ult_large')
        4.times { shopping_cart.add(unlimited_large) }
        expect(shopping_cart.total).to eq (39.90 * 4)
      end

      it 'returns total with the discount applied' do
        unlimited_small = MobilePhonePricingRule.find_by_product_code('ult_small')
        unlimited_large = MobilePhonePricingRule.find_by_product_code('ult_large')
        2.times { shopping_cart.add(unlimited_small) }
        4.times { shopping_cart.add(unlimited_large) }
        expect(shopping_cart.total).to eq 209.4
      end
    end
  end
end
