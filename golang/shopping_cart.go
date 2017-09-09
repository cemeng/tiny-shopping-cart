package main

import (
	"errors"
	"fmt"
	"math"
)

type ShoppingCart struct {
	Items       []Product
	PricingRule PricingRules
}

func (s *ShoppingCart) add(item Product, promoCode ...func(string)) {
	s.Items = append(s.Items, item)
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
	var itemsTotal float64 = 0.0
	for _, item := range s.Items {
		itemsTotal = itemsTotal + item.Price
	}
	return Round(itemsTotal-s.threeForTwoDiscount()-s.ultLargeBulkDiscount(), 2)
}

func (s *ShoppingCart) threeForTwoDiscount() float64 {
	numberOfUltSmall := 0
	var discount float64 = 0.0
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
	var discount float64 = 0.0
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

// from the internet
func Round(f float64, places int) float64 {
	shift := math.Pow(10, float64(places))
	return math.Floor(float64(f)*shift+.5) / shift
}

func (s *ShoppingCart) clear() {
	s.Items = nil
}

func NewShoppingCart(pricingRule PricingRules) ShoppingCart {
	shoppingCart := ShoppingCart{}
	shoppingCart.PricingRule = pricingRule
	return shoppingCart
}

type Product struct {
	Code  string
	Name  string
	Price float64
}

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
	item1, _ := pricingRule.findPricingByCode("ult_small")
	ultMedium, _ := pricingRule.findPricingByCode("ult_medium")
	shoppingCart.add(item1)
	fmt.Println(shoppingCart.Items)
  shoppingCart.clear()
	shoppingCart.add(ultMedium)
	shoppingCart.add(ultMedium)
	fmt.Println(shoppingCart.items())
}
