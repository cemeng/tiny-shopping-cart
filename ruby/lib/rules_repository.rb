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
