//
//  Country.swift
//  SwiftData Pagination
//
//  Created by Matteo Buompastore on 11/03/24.
//

import SwiftData

@Model
class Country {
    var name: String
    var code: String
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}

struct CodableCountry: Codable {
    
    var name: String
    var code: String
    
    enum CodingKeys: CodingKey {
        case name
        case code
    }
    
}
