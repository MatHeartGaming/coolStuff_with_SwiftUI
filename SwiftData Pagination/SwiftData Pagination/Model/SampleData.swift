//
//  SampleData.swift
//  SwiftData Pagination
//
//  Created by Matteo Buompastore on 11/03/24.
//

import Foundation

struct SampleData {
    
    static var countries = [Country]()
    static var codableCountries = [CodableCountry]()
    
    static func loadData()  {
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json")
        else {
            print("Json file not found")
            return
        }
        
        let data = try? Data(contentsOf: url)
        let codableCountries = try? JSONDecoder().decode([CodableCountry].self, from: data!)
        guard let codableCountries else { return }
        self.codableCountries.append(contentsOf: codableCountries)
        
    }
    
}
