//
//  ContentView.swift
//  Custom File Extension Import & Export
//
//  Created by Matteo Buompastore on 10/01/24.
//

import SwiftUI
import CryptoKit

struct ContentView: View {
    
    // MARK: - UI
    @State private var transactions: [Transaction] = []
    @State private var importedTransactions = false
    
    var body: some View {
        NavigationStack {
            List(transactions) { transaction in
                
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(transaction.title)
                        
                        Text(transaction.date.formatted(date: .numeric, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.gray)
                    } //: VSTACK
                    
                    Spacer(minLength: 0)
                    
                    Text("$\(Int(transaction.amount))")
                        .font(.callout.bold())
                    
                } //: HSTACK
                
            } //: LIST
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "plus") {
                        /// Add dummy items
                        transactions.append(Transaction())
                    }
                } //: ITEM ADD
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "square.and.arrow.down.fill") {
                        importedTransactions.toggle()
                    }
                } //: ITEM IMPORT
                
                ToolbarItem(placement: .topBarLeading) {
                    /// Share link
                    ShareLink(item: Transactions(transactions: transactions),
                              preview: SharePreview("Share", image: "square.and.arrow.up.fill")
                    )
                } //: ITEM SHARE
                
            }
        } //: NAVIGATION
        .fileImporter(isPresented: $importedTransactions, allowedContentTypes: [.trnExportType]) { result in
            switch result {
                
            case .success(let URL):
                decryptData(in: URL)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func decryptData(in url: URL) {
        do {
            let encryptedData = try Data(contentsOf: url)
            /// Decryption
            let decryptData = try AES.GCM.open(.init(combined: encryptedData), using: .trnKey)
            /// Decoding
            let decodedTransactions = try JSONDecoder().decode(Transactions.self, from: decryptData)
            /// Adding to the List
            withAnimation {
                self.transactions = decodedTransactions.transactions
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

#Preview {
    ContentView()
}
