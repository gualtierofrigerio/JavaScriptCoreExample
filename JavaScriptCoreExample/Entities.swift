//
//  Entities.swift
//  JavaScriptCoreExample
//
//  Created by Gualtiero Frigerio on 19/11/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Foundation
import JavaScriptCore

struct Product:Codable {
    var name:String
    var price:Float
    var quantity:Int
    var totalPrice:Float?
}

struct ProductsFromJSON:Codable {
    var name:String
    var price:Float
}

@objc protocol ProductJSExport:JSExport {
    var name:String {get set}
    var price:Float {get set}
    var quantity:Int {get set}
    
    static func createProduct(name:String, price:Float, quantity:Int) -> ProductJS
}

class ProductJS: NSObject, ProductJSExport {
    dynamic var name: String
    dynamic var price: Float
    dynamic var quantity: Int
    
    init(name:String, price:Float, quantity:Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
    
    class func createProduct(name: String, price: Float, quantity: Int) -> ProductJS {
        ProductJS(name: name, price: price, quantity: quantity)
    }
}

struct Order:Codable {
    var totalPrice:Double
    var discount:Double
    var products:[Product]
    
    init() {
        totalPrice = 0.0
        discount = 0.0
        products = []
    }
    
    func getTotalPrice() -> String {
        String(format:"%.2f", totalPrice)
    }
    
    func getDiscount() -> String {
        String(format:"%.2f", discount)
    }
}
