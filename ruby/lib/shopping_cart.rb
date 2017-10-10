require 'products_repository'
require 'rules_repository'

class ShoppingCart
  def initialize(pricing_rule)
    clear
    @pricing_rule = pricing_rule
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

  # bundled items are shown on items, but their prices do not count towards the total
  def bundled_items
    RulesRepository.new(@items, @pricing_rule).additional_items
  end

  def items_total
    (@items.inject(0) { |sum, item| sum + item[:price] })
  end

  def total_with_discount_from_specials
    items_total - discount_from_specials
  end

  def discount_from_specials
    RulesRepository.new(@items, @pricing_rule).discount_applicable
  end

  def discount_from_promos
    result = @promo_codes.inject(0) do |sum, code|
      sum + i_love_amaysim_discount if code == 'I<3AMAYSIM'
    end
    result
  end

  def i_love_amaysim_discount
    0.1 * total_with_discount_from_specials
  end
end
