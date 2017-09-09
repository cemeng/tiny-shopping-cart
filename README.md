# tiny-shopping-cart

A minimalistic shopping cart implementation written in Ruby and Golang.

# Ruby version

```
git clone https://github.com/cemeng/tiny-shopping-cart
cd tiny-shopping-cart/ruby
bundle install
```

## Run spec

```
rspec --format=documentation
```

## Interacting with the shopping cart

Use Interactive Ruby (irb) which comes with ruby:
```
irb -r ./lib/shopping_cart.rb
```

Then you will have access to ```ShoppingCart``` object and interact with it.

Here is an example:
```
irb(main):001:0> cart = ShoppingCart.new(MobilePhonePricingRule)
=> #<ShoppingCart:0x007fab019525f0 @items=[], @bundled_items=[], @promo_codes=[], @pricing_rule=MobilePhonePricingRule>
irb(main):002:0> item1 = MobilePhonePricingRule.find_by_product_code('ult_small')
=> {:code=>"ult_small", :name=>"Unlimited 1GB", :price=>24.9}
irb(main):003:0> item2 = MobilePhonePricingRule.find_by_product_code('ult_small')
=> {:code=>"ult_small", :name=>"Unlimited 1GB", :price=>24.9}
irb(main):004:0> cart.add(item1)
=> nil
irb(main):005:0> cart.add(item2, 'I<3AMAYSIM')
=> ["I<3AMAYSIM"]
irb(main):006:0> cart.total
=> 44.82
irb(main):007:0> cart.items
=> [{:code=>"ult_small", :name=>"Unlimited 1GB", :price=>24.9}, {:code=>"ult_small", :name=>"Unlimited 1GB", :price=>24.9}]
irb(main):008:0> cart.clear
```
