//
//  ContentView.swift
//  JavaScriptCoreExample
//
//  Created by Gualtiero Frigerio on 19/11/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import SwiftUI

struct OrderView: View {
    var dataSource:DataSource
    
    var body: some View {
        VStack(alignment:.leading) {
            Text("Total \(dataSource.order.getTotalPrice())")
            Text("Discount \(dataSource.order.getDiscount())")
            Text("Products in order:")
            List(dataSource.order.products, id: \.name) { product in
                HStack {
                    Text(product.name)
                    Spacer()
                    Text("\(product.totalPrice ?? 0)")
                }
            }
        }
    }
}

struct ContentView: View {
    let dataSource = DataSource()
    @State var showOrder = false
    
    var body: some View {
        NavigationView {
            List(dataSource.products, id:\.name) {product in
                HStack {
                    Text(product.name)
                    Spacer()
                    Button(action: {
                        self.addToOrder(product: product)
                    }) {
                        Text("Add")
                    }
                }
            }
            .navigationBarTitle("Products")
            .navigationBarItems(trailing: Button("Show order") {
                self.showOrder.toggle()
            })
        }
        .sheet(isPresented: $showOrder) {
            OrderView(dataSource:self.dataSource)
        }
    }
}

extension ContentView {
    private func addToOrder(product:Product) {
        var productToAdd = product
        productToAdd.quantity = 1
        dataSource.addProductToOrder(productToAdd)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
