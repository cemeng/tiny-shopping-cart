class ShoppingCart
  attr_reader :items

  def initialize(pricing_rule)
    @items = []
    @pricing_rule = pricing_rule
  end

  def add(item, promo_code = nil)
    @items << item
  end

  def total
    total_with_discounts
  end

  private

  def items_total
    (@items.inject(0) { |sum, item| sum + item[:price] }).round(2)
  end

  def total_with_discounts
    (items_total - discounts).round(2)
  end

  def discounts
    (two_for_one_discount + bulk_discount_for_ult_large)
  end

  def two_for_one_discount
    quantity = @items.count { |i| i[:code] == 'ult_small' }
    (quantity / 3) * @pricing_rule.find_by_product_code('ult_small')[:price]
  end

  def bulk_discount_for_ult_large
    quantity = @items.count { |i| i[:code] == 'ult_large' }
    if quantity > 3
      return quantity * (@pricing_rule.find_by_product_code('ult_large')[:price] - 39.90)
    end
    0
  end
end

class MobilePhonePricingRule
  RULES = [
    { code: 'ult_small',  name: 'Unlimited 1GB', price: 24.9 },
    { code: 'ult_medium', name: 'Unlimited 2GB', price: 29.9 },
    { code: 'ult_large',  name: 'Unlimited 5GB', price: 44.9 },
    { code: '1gb',        name: '1 GB Data-pack', price: 9.90 }
  ]

  def self.find_by_product_code(product_code)
    RULES.select { |i| i[:code] == product_code }.first
  end
end
