package main

import "testing"

func TestShoppingCart(t *testing.T) {
	pricingRule := NewPricingRules()
	shoppingCart := NewShoppingCart(pricingRule)
	ultSmall, _ := pricingRule.findPricingByCode("ult_small")
	ultMedium, _ := pricingRule.findPricingByCode("ult_medium")
	ultLarge, _ := pricingRule.findPricingByCode("ult_large")
	dataPack, _ := pricingRule.findPricingByCode("1gb")

	shoppingCart.add(ultSmall)
	if len(shoppingCart.Items) != 1 {
		t.Errorf("Expecting 1 item on shopping cart")
	}

	if shoppingCart.total() != ultSmall.Price {
		t.Errorf("Total price is incorrect")
	}

	shoppingCart.clear()
	shoppingCart.add(ultSmall)
	shoppingCart.add(ultSmall)
	shoppingCart.add(ultSmall)
	if shoppingCart.total() != Round(ultSmall.Price*2, 2) {
		t.Errorf("Total is incorrect for 3 for 2 deal on Unlimited 1GB sims, expecting %f but got %f", (ultSmall.Price * 2), shoppingCart.total())
	}

	shoppingCart.clear()
	shoppingCart.add(ultLarge)
	shoppingCart.add(ultLarge)
	shoppingCart.add(ultLarge)
	shoppingCart.add(ultLarge)
	if shoppingCart.total() != Round(39.90*4, 2) {
		t.Errorf("Total unlimited 5GB sims bulk discount, expecting %f but got %f", Round(39.90*4, 2), shoppingCart.total())
	}

	shoppingCart.clear()
	shoppingCart.add(ultMedium)
	shoppingCart.add(ultMedium)
	numberOfDataPacks := 0
	for _, item := range shoppingCart.items() {
		if item.Code == "1gb" {
			numberOfDataPacks++
		}
	}
	if numberOfDataPacks != 2 {
		t.Errorf("Expecting two 1GB data packs but found %f", numberOfDataPacks)
	}

	shoppingCart.clear()
	shoppingCart.add(ultMedium, "I<3AMAYSIM")
	if shoppingCart.total() != 0.9*ultMedium.Price {
		t.Errorf("10 percent discount from I<3AMAYSIM code is not applied")
	}

	shoppingCart.clear()
	shoppingCart.add(ultSmall)
	shoppingCart.add(ultSmall)
	shoppingCart.add(ultSmall)
	shoppingCart.add(ultLarge)
	if shoppingCart.total() != 94.70 {
		t.Errorf("Incorect total %f", shoppingCart.total())
	}

	shoppingCart.clear()
	shoppingCart.add(ultSmall)
	shoppingCart.add(ultSmall)
	shoppingCart.add(ultLarge)
	shoppingCart.add(ultLarge)
	shoppingCart.add(ultLarge)
	shoppingCart.add(ultLarge)
	if shoppingCart.total() != 209.40 {
		t.Errorf("Incorect total %f", shoppingCart.total())
	}

	shoppingCart.clear()
	shoppingCart.add(ultSmall)
	shoppingCart.add(ultMedium)
	shoppingCart.add(ultMedium)
	if shoppingCart.total() != 84.70 {
		t.Errorf("Incorect total %f", shoppingCart.total())
	}

	shoppingCart.clear()
	shoppingCart.add(ultSmall)
	shoppingCart.add(dataPack, "I<3AMAYSIM")
	if shoppingCart.total() != 31.32 {
		t.Errorf("Incorect total %f", shoppingCart.total())
	}
}
