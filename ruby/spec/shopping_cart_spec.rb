require 'shopping_cart'

RSpec.describe ShoppingCart do
  let(:shopping_cart)     { ShoppingCart.new }
  let(:unlimited_small)   { ProductsRepository.find_by_product_code('ult_small') }
  let(:unlimited_medium)  { ProductsRepository.find_by_product_code('ult_medium') }
  let(:unlimited_large)   { ProductsRepository.find_by_product_code('ult_large') }
  let(:data_pack_1gb)     { ProductsRepository.find_by_product_code('1gb') }

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

    describe 'promos' do
      context 'I<3AMAYSIM code' do
        it 'gives 10% discount of the total' do
          shopping_cart.add(unlimited_small, 'I<3AMAYSIM')
          expect(shopping_cart.total).to eq (0.9 * unlimited_small[:price])
        end
      end
    end
  end

  describe '#items' do
    it 'returns all items on the shopping cart' do
      2.times { shopping_cart.add(unlimited_small) }
      expect(shopping_cart.items).to eq [ unlimited_small, unlimited_small ]
    end
  end

  describe 'bundled items' do
    context '1GB free data pack per 2GB unlimited' do
      it 'adds 1GB data pack for every 2GB unlimited plan' do
        2.times { shopping_cart.add(unlimited_medium) }
        expect(shopping_cart.items).to eq [ unlimited_medium, unlimited_medium, data_pack_1gb, data_pack_1gb ]
      end

      it '1GB data pack added does not add to the total' do
        2.times { shopping_cart.add(unlimited_medium) }
        expect(shopping_cart.total).to eq (2 * unlimited_medium[:price])
      end
    end
  end
end
