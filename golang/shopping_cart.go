package main

import (
  "fmt"
  "errors"
)

type ShoppingCart struct {
  Items []Product
  PricingRule PricingRules
}

func (s *ShoppingCart) add(item Product) []Product {
  result := append(s.Items, item)
  return result
}

func NewShoppingCart(pricingRule PricingRules) ShoppingCart {
  shoppingCart := ShoppingCart{}
  shoppingCart.PricingRule = pricingRule
  return shoppingCart
}

type Product struct {
  Code string
  Name string
  Price float32
}

type PricingRules struct {
  Pricing []Product
}

func NewPricingRules() PricingRules {
  pricingRule := PricingRules{}
  pricingRule.Pricing = []Product{
    Product { Code: "ult_small", Name: "Unlimited 1GB", Price: 24.9, },
    Product { Code: "ult_medium", Name: "Unlimited 2GB", Price: 29.9, },
    Product { Code: "ult_large", Name: "Unlimited 5GB", Price: 44.9, },
    Product { Code: "1gb", Name: "1 GB Data-pack", Price: 9.9, },
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
  // fmt.Println(pricingRule.Pricing)
  fmt.Println(pricingRule.findPricingByCode("ult_small"))
  shoppingCart := NewShoppingCart(pricingRule)
  fmt.Println(shoppingCart)
}
