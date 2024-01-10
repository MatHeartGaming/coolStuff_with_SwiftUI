//
//  Transaction.swift
//  Custom File Extension Import & Export
//
//  Created by Matteo Buompastore on 10/01/24.
//

import SwiftUI
import CoreTransferable
import UniformTypeIdentifiers
import CryptoKit

struct Transaction: Identifiable, Codable {
    
    var id = UUID()
    var title: String
    var date: Date
    var amount: Double
    
    init() {
        self.title = "Sample Text"
        self.amount = .random(in: 5000...10000)
        let calendar = Calendar.current
        self.date = calendar.date(byAdding: .day, value: .random(in: 1...100), to: .now) ?? .now
    }
    
}

struct Transactions: Codable, Transferable {
    
    var transactions: [Transaction]
    
    static var transferRepresentation: some TransferRepresentation {
        /// Encrypted version
        DataRepresentation(exportedContentType: .trnExportType) { data in
            let data = try JSONEncoder().encode(data)
            guard let encryptedData = try AES.GCM.seal(data, using: .trnKey).combined else {
                throw EncryptedError.failed
            }
            return encryptedData
        }
        .suggestedFileName("Transactions \(Date())")
        
        /// Easy and fast version
        /*CodableRepresentation(contentType: .trnExportType)
            .suggestedFileName("Transactions \(Date())")*/
    }
    
    enum EncryptedError: Error {
        case failed
    }
    
}


//MARK: - EXTENIONS

extension SymmetricKey {
    
    static var trnKey: SymmetricKey {
        let key = "MatBuompy".data(using: .utf8)!
        let sha256 = SHA256.hash(data: key)
        return .init(data: sha256)
    }
    
}

extension UTType {
    
    static var trnExportType = UTType(exportedAs: "it.matbuompy.Custom-File-Extension")
    
}
