package main

import (
  "fmt"
  "errors"
)

// need shopping cart struct
// type ShoppingCart struct {
// }

type Pricing struct {
  Code string
  Name string
  Price float32
}

type PricingRules struct {
  Pricing []Pricing
}

func NewPricingRules() PricingRules {
  pricingRule := PricingRules{}
  pricingRule.Pricing = []Pricing{
    Pricing { Code: "ult_small", Name: "Unlimited 1GB", Price: 24.9, },
    Pricing { Code: "ult_medium", Name: "Unlimited 2GB", Price: 29.9, },
    Pricing { Code: "ult_large", Name: "Unlimited 5GB", Price: 44.9, },
    Pricing { Code: "1gb", Name: "1 GB Data-pack", Price: 9.9, },
  }
  return pricingRule
}

func (p *PricingRules) findPricingByCode(code string) (Pricing, error) {
  for _, pricing := range p.Pricing {
     if pricing.Code == code {
         return pricing, nil
     }
  }
  return Pricing{}, errors.New("Pricing not found")
}

func main() {
  pricingRule := NewPricingRules()
  // fmt.Println(pricingRule.Pricing)
  fmt.Println(pricingRule.findPricingByCode("ult_small"))
}
