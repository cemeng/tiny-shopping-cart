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

  # bundled items is shown on items, but does not count towards the total
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

class RulesRepository
  def initialize(items, pricing_rule)
    @items = items
    @pricing_rule = pricing_rule
  end

  def discount_applicable
    three_for_two_discount + bulk_discount_for_ult_large
  end

  def additional_items
    free_data_packs
  end

  private

  def free_data_packs
    result = []
    data_pack = @pricing_rule.find_by_product_code('1gb')
    num_of_medium_items = @items.count { |i| i[:code] == 'ult_medium' }
    num_of_medium_items.times { result << data_pack }
    result
  end

  def three_for_two_discount
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
