//
//  Product.swift
//  Sticky Header Autoscrollable Tabs
//
//  Created by Matteo Buompastore on 19/02/24.
//

import SwiftUI

struct Product: Identifiable, Hashable {
    var id: UUID = UUID()
    var type: ProductType
    var title: String
    var subtitle: String
    var price: String
    var productImage: String
}

enum ProductType: String, CaseIterable {
    case iphone = "iPhone"
    case ipad = "iPad"
    case macbook = "MacBook"
    case desktop = "Mac Desktop"
    case appleWatch = "Apple Watch"
    case airpods = "Airpods"
    
    var tabID: String {
        /// Unique ID for yab scrolling
        return self.rawValue + self.rawValue.prefix(4)
    }
}

var products: [Product] = [
    /// Apple Watch
    Product(type: .appleWatch, title: "Apple Watch", subtitle: "Ultra: Alphine Loop", price: "$999", productImage: "AppleWatchUltra"),
    Product(type: .appleWatch, title: "Apple Watch", subtitle: "Series 8", price: "$599", productImage: "AppleWatch8"),
    Product(type: .appleWatch, title: "Apple Watch", subtitle: "Series 6", price: "359", productImage: "AppleWatch6"),
    
    /// iPhones
    Product(type: .iphone, title: "iPhone 15 Pro", subtitle: "A17 Pro", price: "$1299", productImage: "iPhone15Pro"),
    Product(type: .iphone, title: "iPhone 14 Pro", subtitle: "A16 Pro", price: "$699", productImage: "iPhone14Pro"),
    Product(type: .iphone, title: "iPhoneSE", subtitle: "Chip A Scassato", price: "$399", productImage: "iPhoneSE"),
    
    /// Macbooks
    Product(type: .macbook, title: "Macbook Air", subtitle: "M2 - Silver a scatti", price: "$1299", productImage: "MacbookAir"),
    Product(type: .macbook, title: "Macbook Air", subtitle: "M2 Pro a colori", price: "$2499", productImage: "MacbookPro"),
    
    /// iPads
    Product(type: .ipad, title: "iPad", subtitle: "The weakest", price: "$499", productImage: "iPad"),
    Product(type: .ipad, title: "iPad Air", subtitle: "M1 - Gray", price: "$699", productImage: "iPadAir"),
    Product(type: .ipad, title: "iPad Pro", subtitle: "M2 - Gray", price: "$999", productImage: "iPadPro"),
    
    /// Desktops
    Product(type: .desktop, title: "Mac Studio", subtitle: "M2 Max - Gray", price: "$1999", productImage: "MacStudio"),
    Product(type: .desktop, title: "Mac Mini", subtitle: "M2 - Gold", price: "$699", productImage: "MacMini"),
    Product(type: .desktop, title: "iMac", subtitle: "M1 - Purple", price: "$1599", productImage: "iMac"),
    
    /// Airpods
    Product(type: .airpods, title: "Airpods", subtitle: "Pro 2nd gen", price: "$249", productImage: "AirpodsPro"),
    Product(type: .airpods, title: "Airpods", subtitle: "2nd gen", price: "$129", productImage: "Airpods2"),
    Product(type: .airpods, title: "Airpods", subtitle: "3nd gen", price: "$179", productImage: "Airpods3"),
    
]
