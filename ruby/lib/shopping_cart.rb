require 'products_repository'
require 'rules_repository'

class ShoppingCart
  def initialize
    clear
  end

  def add(item, promo_code = nil)
    @items << item
    @promo_codes << promo_code if promo_code
  end

  def total
    (total_with_discount_from_specials - discount_from_promos).round(2)
  end

  def clear
    @items = []
    @bundled_items = []
    @promo_codes = []
  end

  def items
    @items + bundled_items
  end

  private

  def rules_repository
    RulesRepository.new(@items)
  end

  # Bundled items are items that automatically added based on existing items on the cart
  # these items do not count towards counting the total price
  def bundled_items
    rules_repository.bundled_items
  end

  def items_total
    (@items.inject(0) { |sum, item| sum + item[:price] })
  end

  def total_with_discount_from_specials
    items_total - rules_repository.discount_applicable
  end

  def discount_from_promos
    result = @promo_codes.inject(0) do |sum, code|
      sum + i_love_myself_discount if code == 'I<3MYSELF'
    end
    result
  end

  def i_love_myself_discount
    0.1 * total_with_discount_from_specials
  end
end
