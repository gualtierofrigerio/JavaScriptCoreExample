//
//  DataSource.swift
//  JavaScriptCoreExample
//
//  Created by Gualtiero Frigerio on 19/11/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Foundation

class DataSource {
    var products:[Product] = []
    var order = Order()
    var jsHandler = JSCommunicationHandler()
    
    init() {
        if let products = loadProducts() {
            self.products = products
        }
        if let javascriptUrl = Bundle.main.url(forResource: "order", withExtension: "js") {
            jsHandler.loadSourceFile(atUrl: javascriptUrl)
        }
        jsHandler.setObject(object: ProductJS.self, withName: "ProductJS")
        
        let result = jsHandler.evaluateJavaScript("getProduct('name', 11)")
        if let product = result?.toObject() as? ProductJS {
            print("created product with name \(product.name)")
        }
    }
    
    func addProductToOrder(_ product:Product) {
        var productToAdd = product
        if let totalPrice = getTotalPriceOfProduct(product) {
            print("total price of product = \(totalPrice)")
            productToAdd.totalPrice = totalPrice
        }
        if let priceAndDiscount = getPriceAndDiscountOfProduct(product) {
            print("total price = \(priceAndDiscount.0) discount = \(priceAndDiscount.1)")
        }
        order.products.append(productToAdd)
        if let orderTotalPrice = getTotalPriceAndDiscountOfOrder(order) {
            order.totalPrice = orderTotalPrice.0
            order.discount = orderTotalPrice.1
        }
    }
}

extension DataSource {
    private func loadProducts() -> [Product]? {
        guard let productsUrl = Bundle.main.url(forResource: "products", withExtension: "json"),
            let data = try? Data(contentsOf: productsUrl) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let productsArray = try? decoder.decode([ProductsFromJSON].self, from: data) else {
            return nil
        }
        let products = productsArray.map({Product(name: $0.name, price: $0.price, quantity: 0)})
        return products
    }
    
    private func getTotalPriceOfProduct(_ product:Product) -> Float? {
        if let value = jsHandler.callFunction(functionName: "getTotalPriceOfProduct", withData: product, type:Product.self) {
            if value.isNumber {
                return value.toNumber() as? Float
            }
            else {
                print("error while getting total price for \(product.name)")
            }
        }
        return nil
    }
    
    private func getPriceAndDiscountOfProduct(_ product:Product) -> (Double, Double)? {
        if let value = jsHandler.callFunction(functionName: "getPriceAndDiscountOfProduct", withData: product, type:Product.self) {
            if value.isObject,
               let dictionary = value.toObject() as? [String:Any] {
                let price = dictionary["price"] as? Double ?? 0.0
                let discount = dictionary["discount"] as? Double ?? 0.0
                return (price, discount)
            }
            else {
                print("error while getting price and discount for \(product.name)")
            }
        }
        return nil
    }
    
    private func getTotalPriceAndDiscountOfOrder(_ order:Order) -> (Double,Double)? {
        if let value = jsHandler.callFunction(functionName: "getTotalPriceAndDiscountOfOrder", withData: order, type:Order.self) {
            if value.isObject,
               let dictionary = value.toObject() as? [String:Any] {
                let price = dictionary["price"] as? Double ?? 0.0
                let discount = dictionary["discount"] as? Double ?? 0.0
                return (price, discount)
            }
            else {
                print("error while getting price and discount for order")
            }
        }
        return nil
    }
}
