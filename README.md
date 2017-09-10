# tiny-shopping-cart

A tiny shopping cart implementation written in Ruby and Golang.

# Installation

```
git clone https://github.com/cemeng/tiny-shopping-cart
```

# Ruby version

## Installation

```
cd tiny-shopping-cart/ruby
gem install bundle
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

# Golang version

The shopping cart code can be found at:
```
tiny-shopping-cart/golang/shopping_cart.go
```

The test is at:
```
tiny-shopping-cart/golang/shopping_cart_test.go
```

Please note that the golang code is written by someone with only few days experience of programming with Golang, so
it is probably not as 'idiomatic' as it should be :)

# Run test

```
cd golang
go test
```

## Interacting with shopping cart

Modify the main function on shopping_cart.go to interact with the shopping cart.

Then run the code by:
```
cd golang
go run shopping_cart.go
```

However using The Go Playground is the easiest, I have created one here: https://play.golang.org/p/D8y1FMqLsA

Below is an example of adding a product to the shopping cart and list the items and then prints out the total.
```
func main() {
	  pricingRule := NewPricingRules()
	  shoppingCart := NewShoppingCart(pricingRule)
    ultSmall, _ := pricingRule.findPricingByCode("ult_small")

    shoppingCart.add(ultSmall)
    // shoppingCart.items() to list all items in shopping cart
    fmt.Println(shoppingCart.items())
    fmt.Println(shoppingCart.total())

    // empty shopping cart
    shoppingCart.clear()
}
```
