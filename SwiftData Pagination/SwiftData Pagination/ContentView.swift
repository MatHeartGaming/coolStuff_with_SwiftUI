//
//  ContentView.swift
//  SwiftData Pagination
//
//  Created by Matteo Buompastore on 11/03/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // MARK: - Properties
    @State private var paginationOffset: Int?
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                PaginatedView(paginationOffset: $paginationOffset) { countries in
                    ForEach(countries) { country in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(country.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(country.code)
                                .font(.callout)
                                .foregroundStyle(.gray)
                        } //: VSTACK
                        .customOnAppear(true) {
                            if let paginationOffset, countries.last == country {
                                self.paginationOffset = paginationOffset + 50
                            }
                        }
                    } //: Loop Countries
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                Text("Countries")
                                    .font(.headline)
                                Text("Count = \(countries.count)")
                                    .font(.caption)
                            }
                        }
                    } //: Toolbar
                }
            } //: LIST
        } //: NAVIGATION
        .onAppear {
            if paginationOffset == nil {
                paginationOffset = 0
            }
        }
    }
}

extension View {
    @ViewBuilder
    func customOnAppear(_ callOnce: Bool = true, action: @escaping () -> Void) -> some View {
        self
            .modifier(CustomOnAppearModifier(callOnce: callOnce, action: action))
    }
}

fileprivate struct CustomOnAppearModifier: ViewModifier {
    
    var callOnce: Bool
    var action: () -> Void
    @State private var isTriggered = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if callOnce {
                    if !isTriggered {
                        action()
                        isTriggered = true
                    }
                } else {
                    action()
                }
            }
    }
    
}

struct PaginatedView<Content: View>: View {
    
    // MARK: - Properties
    var itemsPerPage: Int = 20
    @Binding var paginationOffset: Int?
    @ViewBuilder var content: ([Country]) -> Content
    
    /// UI
    @State private var countries: [Country] = []
    @Environment(\.modelContext) private var context
    
    var body: some View {
        content(countries)
            .onChange(of: paginationOffset) { oldValue, newValue in
                guard let newValue else { return }
                do {
                    var descriptor = FetchDescriptor<Country>()
                    /// Total Count
                    let totalCount = try context.fetchCount(descriptor)
                    print("Total Count: \(totalCount)")
                    /// Setting up descriptor for pagination
                    descriptor.fetchLimit = itemsPerPage
                    /// Limiting page Offset
                    let pageOffset = min(min(totalCount, newValue), countries.count)
                    descriptor.fetchOffset = pageOffset
                    
                    if totalCount == countries.count {
                        /// Setting page offset to Total Count
                        paginationOffset = totalCount
                    } else {
                        /// Get new data
                        let newData = try context.fetch(descriptor)
                        countries.append(contentsOf: newData)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
}

#Preview {
    ContentView()
}
