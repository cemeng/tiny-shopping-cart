require 'shopping_cart'

RSpec.describe ShoppingCart do
  let(:shopping_cart) { ShoppingCart.new(MobilePhonePricingRule) }
  let(:unlimited_small) { MobilePhonePricingRule.find_by_product_code('ult_small') }
  let(:unlimited_medium) { MobilePhonePricingRule.find_by_product_code('ult_medium') }
  let(:unlimited_large) { MobilePhonePricingRule.find_by_product_code('ult_large') }

  describe '#add' do
    it 'adds an item shopping cart' do
      expect { shopping_cart.add(unlimited_small) }.to change { shopping_cart.items.count }.by(1)
    end
  end

  describe '#total' do
    describe 'with no specials nor promos are applicable' do
      it 'sums the price of all items in the cart' do
        shopping_cart.add(unlimited_small)
        shopping_cart.add(unlimited_medium)
        expect(shopping_cart.total).to eq unlimited_small[:price] + unlimited_medium[:price]
      end
    end

    describe 'specials' do
      context '3 for 2 deal for Unlimited 1GB special' do
        it 'when 3 Unlimited 1GB is added, only 2 of them is counted' do
          3.times { shopping_cart.add(unlimited_small) }
          expect(shopping_cart.total).to eq (unlimited_small[:price] * 2)
        end
      end

      context '3 5GB special' do
        it 'when 4 Unlimited 5GB is added, each has its price reduced to 39.9' do
          4.times { shopping_cart.add(unlimited_large) }
          expect(shopping_cart.total).to eq (39.90 * 4)
        end

        it 'when combined with other plans, the total should be correct' do
          2.times { shopping_cart.add(unlimited_small) }
          4.times { shopping_cart.add(unlimited_large) }
          expect(shopping_cart.total).to eq 209.4
        end
      end
    end
  end
end
