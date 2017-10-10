package main

import (
	"errors"
	"fmt"
	"math"
)

// ShoppingCart provides shopping cart functionality
// It maintains a list of items and provides API for adding / removing item
// and calculating total price.
type ShoppingCart struct {
	Items       []Product
	PricingRule PricingRules
	PromoCode   string
}

func (s *ShoppingCart) add(item Product, promoCode ...string) {
	s.Items = append(s.Items, item)
	if len(promoCode) == 1 {
		s.PromoCode = promoCode[0]
	}
}

func (s *ShoppingCart) items() []Product {
	return append(s.Items, s.freeDataPacks()...)
}

func (s *ShoppingCart) freeDataPacks() []Product {
	result := []Product{}
	dataPack, _ := s.PricingRule.findPricingByCode("1gb")
	numOfUltMedium := 0
	for _, item := range s.Items {
		if item.Code == "ult_medium" {
			numOfUltMedium++
		}
	}
	for i := 0; i < numOfUltMedium; i++ {
		result = append(result, dataPack)
	}
	return result
}

func (s *ShoppingCart) total() float64 {
	var itemsTotal float64
	for _, item := range s.Items {
		itemsTotal = itemsTotal + item.Price
	}
	subTotal := itemsTotal - s.threeForTwoDiscount() - s.ultLargeBulkDiscount()
	if s.PromoCode == "I<3AMAYSIM" {
		return Round(subTotal*0.9, 2)
	}
	return Round(subTotal, 2)
}

func (s *ShoppingCart) threeForTwoDiscount() float64 {
	numberOfUltSmall := 0
	var discount float64
	ultSmall, _ := s.PricingRule.findPricingByCode("ult_small")
	for _, item := range s.Items {
		if item.Code == "ult_small" {
			numberOfUltSmall++
		}
	}
	discount = float64((numberOfUltSmall / 3)) * ultSmall.Price
	return discount
}

func (s *ShoppingCart) ultLargeBulkDiscount() float64 {
	numberOfUltLarge := 0
	var discount float64
	ultLarge, _ := s.PricingRule.findPricingByCode("ult_large")
	for _, item := range s.Items {
		if item.Code == "ult_large" {
			numberOfUltLarge++
		}
	}
	discount = float64((numberOfUltLarge / 3)) * ultLarge.Price
	if numberOfUltLarge > 3 {
		discount = float64(numberOfUltLarge) * (ultLarge.Price - 39.90)
	}
	return discount
}

// Round is a function that rounds a float number into specified decimal places
// Note: this is function that I found from the internet
func Round(f float64, places int) float64 {
	shift := math.Pow(10, float64(places))
	return math.Floor(float64(f)*shift+.5) / shift
}

func (s *ShoppingCart) clear() {
	s.Items = nil
	s.PromoCode = ""
}

// NewShoppingCart initialises a ShoppingCart object
func NewShoppingCart(pricingRule PricingRules) ShoppingCart {
	shoppingCart := ShoppingCart{}
	shoppingCart.PricingRule = pricingRule
	return shoppingCart
}

// Product
type Product struct {
	Code  string
	Name  string
	Price float64
}

// PricingRules
// FIXME: perhaps ProductRepository is a better name
type PricingRules struct {
	Pricing []Product
}

func NewPricingRules() PricingRules {
	pricingRule := PricingRules{}
	pricingRule.Pricing = []Product{
		Product{Code: "ult_small", Name: "Unlimited 1GB", Price: 24.9},
		Product{Code: "ult_medium", Name: "Unlimited 2GB", Price: 29.9},
		Product{Code: "ult_large", Name: "Unlimited 5GB", Price: 44.9},
		Product{Code: "1gb", Name: "1 GB Data-pack", Price: 9.9},
	}
	return pricingRule
}

func (p *PricingRules) findPricingByCode(code string) (Product, error) {
	for _, pricing := range p.Pricing {
		if pricing.Code == code {
			return pricing, nil
		}
	}
	return Product{}, errors.New("Pricing not found")
}

func main() {
	pricingRule := NewPricingRules()
	shoppingCart := NewShoppingCart(pricingRule)
	ultSmall, _ := pricingRule.findPricingByCode("ult_small")
	ultMedium, _ := pricingRule.findPricingByCode("ult_medium")

	shoppingCart.add(ultSmall)
	// shoppingCart.items() to list all items in shopping cart
	fmt.Println(shoppingCart.items())
	fmt.Println(shoppingCart.total())

	// empty shopping cart
	shoppingCart.clear()

	// add item and promo code
	shoppingCart.add(ultMedium, "I<3AMAYSIM")
	fmt.Println(shoppingCart.items())
	fmt.Println(shoppingCart.total())
}
