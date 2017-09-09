package main

import "testing"

func TestShoppingCart(t *testing.T) {
	pricingRule := NewPricingRules()
	shoppingCart := NewShoppingCart(pricingRule)
	item1, _ := pricingRule.findPricingByCode("ult_small")
	shoppingCart.add(item1)
	if len(shoppingCart.Items) != 1 {
		t.Errorf("Expecting 1 item on shopping cart")
	}
}
