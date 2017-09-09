package main

import (
  "fmt"
)

// need shopping cart struct
// type ShoppingCart struct {
// }

type Product struct {
  Code string
  Name string
  Price float32
}

type PricingRule struct {
  Pricing []Product
}

// func NewConsole() *Console {
//     return &Console{X: 5}
// }

func main() {
  item1 := Product { Code: "ult_small", Name: "Unlimited 1GB", Price: 24.9, }

  fmt.Println(item1.Price)
}
