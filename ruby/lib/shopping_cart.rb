class ShoppingCart
  attr_reader :items

  def initialize(pricing_rule)
    @items = []
  end

  def add(item, promo_code = nil)
    @items << item
  end

  def total
    items_total
  end

  def items_total
    @items.inject(0) { |sum, item| sum + item[:price] }
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
    RULES.select { |i| i[:code] == product_code }
  end
end
