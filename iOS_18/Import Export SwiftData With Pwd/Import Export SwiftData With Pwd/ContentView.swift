//
//  ContentView.swift
//  Import Export SwiftData With Pwd
//
//  Created by Matteo Buompastore on 19/09/24.
//

import SwiftUI
import SwiftData
import CryptoKit

struct ContentView: View {
    
    // MARK: Properties
    @Query(sort: [.init(\Transaction.transactionDate, order: .reverse)], animation: .snappy) private var transactions: [Transaction]
    @Environment(\.modelContext) private var context
    
    /// UI
    @State private var showAlertTF: Bool = false
    @State private var keyTF: String = ""
    
    /// Exporter
    @State private var exportItem: TransactionTransferable?
    @State private var showFileExporter: Bool = false
    
    /// Importer
    @State private var showFileImporter: Bool = false
    @State private var importedURL: URL?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(transactions) {
                    Text($0.transactionName)
                }
            } //: LIST
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAlertTF.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                } //: Item Trailing
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFileImporter.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                } //: Item Trailing
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        /// Dummy Data
                        let tranaction = generateRandomTransaction()
                        context.insert(tranaction)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                } //: Item Leading
            }
        } //: NAVIGATION
        .alert("Enter Key", isPresented: $showAlertTF) {
            TextField("Key", text: $keyTF)
                .autocorrectionDisabled()
            
            Button("Cancel", role: .cancel) {
                keyTF = ""
                importedURL = nil
            }
            
            Button(importedURL != nil ? "Import" : "Export") {
                if importedURL != nil {
                    importData()
                } else {
                    exportData()
                }
            }
        }
        .fileExporter(isPresented: $showFileExporter, item: exportItem, contentTypes: [.data], defaultFilename: "Transactions") { result in
            switch result {
            case .success(_):
                print("Success!")
            case .failure(let error):
                print("Export Failed \(error.localizedDescription)")
            }
            exportItem = nil
        } onCancellation: {
            exportItem = nil
        } //: FIle Exporter
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.data]) { result in
            switch result {
                case .success(let url):
                importedURL = url
                showAlertTF.toggle()
                case .failure(let error):
                print("Import Failed \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: Functions
    
    private func exportData() {
        Task.detached(priority: .background) {
            do {
                let container = try ModelContainer(for: Transaction.self)
                let context = ModelContext(container)
                
                let descriptor = FetchDescriptor(sortBy: [.init(\Transaction.transactionDate, order: .reverse)])
                let allObjects = try context.fetch(descriptor)
                let exportItem = await TransactionTransferable(transactions: allObjects, key: keyTF)
                
                /// UI Update on Main Thread
                await MainActor.run {
                    self.exportItem = exportItem
                    showFileExporter = true
                    keyTF = ""
                }
                
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    keyTF = ""
                }
            }
        }
    }
    
    private func importData() {
        guard let url = importedURL else { return }
        Task.detached(priority: .background) {
            do {
                /// Sometimes files permission can avoid reading the contents from it. This will avoid those scenarios.
                guard url.startAccessingSecurityScopedResource() else { return }
                
                /// Create a new container in order not to trigger too many UI updates
                let container = try ModelContainer(for: Transaction.self)
                let context = ModelContext(container)
                
                let encryptedData = try Data(contentsOf: url)
                let decryptedData = try await AES.GCM.open(.init(combined: encryptedData), using: .key(keyTF))
                
                let allTransactions = try JSONDecoder().decode([Transaction].self, from: decryptedData)
                
                print(allTransactions.count)
                
                for transaction in allTransactions {
                    context.insert(transaction)
                }
                
                try context.save()
                
                url.stopAccessingSecurityScopedResource()
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    keyTF = ""
                }
                url.stopAccessingSecurityScopedResource()
            }
        }
    }
    
    private func generateRandomTransaction() -> Transaction {
            let names = ["Grocery", "Rent", "Electric Bill", "Salary", "Investment"]
            let randomName = names.randomElement() ?? "Random Transaction"
            
            // Randomize transaction amount between $10.00 and $5000.00
            let randomAmount = Double.random(in: 10...5000)
            
            // Randomize transaction date in the last 30 days
            let randomDate = Calendar.current.date(byAdding: .day, value: Int.random(in: -30...0), to: Date()) ?? Date()
            
            // Randomize transaction category
            let randomCategory: TransactionCategory = Bool.random() ? .income : .expense
            
            return Transaction(transactionName: randomName, transactionDate: randomDate, transactionAmount: randomAmount, transactionCategory: randomCategory)
        }
    
}

/// Swift Data Model
@Model
class Transaction: Codable {
    var transactionName: String
    var transactionDate: Date
    var transactionAmount: Double
    var transactionCategory: TransactionCategory
    
    init(transactionName: String, transactionDate: Date, transactionAmount: Double, transactionCategory: TransactionCategory) {
        self.transactionName = transactionName
        self.transactionDate = transactionDate
        self.transactionAmount = transactionAmount
        self.transactionCategory = transactionCategory
    }
    
    init(transactionName: String, transactionDate: Date, transactionAmount: String, transactionCategory: TransactionCategory) {
        self.transactionName = transactionName
        self.transactionDate = transactionDate
        self.transactionAmount = Double(transactionAmount) ?? 0
        self.transactionCategory = transactionCategory
    }
    
    enum CodingKeys: CodingKey {
        case transactionName
        case transactionDate
        case transactionAmount
        case transactionCategory
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transactionName = try container.decode(String.self, forKey: .transactionName)
        transactionDate = try container.decode(Date.self, forKey: .transactionDate)
        transactionAmount = try container.decode(Double.self, forKey: .transactionAmount)
        transactionCategory = try container.decode(TransactionCategory.self, forKey: .transactionCategory)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transactionName, forKey: .transactionName)
        try container.encode(transactionDate, forKey: .transactionDate)
        try container.encode(transactionAmount, forKey: .transactionAmount)
        try container.encode(transactionCategory, forKey: .transactionCategory)
    }
    
}

struct TransactionTransferable: Transferable {
    var transactions: [Transaction]
    var key: String
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .data, exporting: {
            let data = try JSONEncoder().encode($0.transactions)
            guard let encrypedData = try AES.GCM.seal(data, using: .key($0.key)).combined else {
                throw EncryptionError.encryptionFailed
            }
            return encrypedData
        })
    }
    
    enum EncryptionError: Error {
        case encryptionFailed
    }
    
}

extension SymmetricKey {
    static func key(_ value: String) -> SymmetricKey {
        let keyData = value.data(using: .utf8)!
        let sha256 = SHA256.hash(data: keyData)
        return .init(data: sha256)
    }
}

enum TransactionCategory: String, Codable {
    case income = "Income"
    case expense = "Expense"
}

#Preview {
    ContentView()
        .modelContainer(for: Transaction.self)
}
