//
//  CategoryView.swift
//  ExpenseTracker
//
//  Created by Matteo Buompastore on 07/12/23.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    
    //MARK: - QUERIES
    @Query(animation: .snappy) private var allCategories: [Category]
    @Environment(\.modelContext) private var context
    
    //MARK: - UI
    @State private var addCategory: Bool = false
    @State private var categoryName: String = ""
    
    /// Category Delete Request
    @State private var deleteRequest = false
    @State private var requestCategory: Category?
    
    var body: some View {
        NavigationStack {
            List {
                
                ForEach(sortedCategoriesByExpensesCount) { category in
                    DisclosureGroup {
                        if let expenses = category.expanses, !expenses.isEmpty {
                            ForEach(expenses) { expense in
                                ExpenseCardView(expense: expense, displayTag: false)
                            }
                        } else {
                            ContentUnavailableView {
                                Label("No expenses", systemImage: "tray.fill")
                            }
                        }
                    } label: {
                        Text(category.categoryName)
                    } //: Disclosure Group
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            deleteRequest.toggle()
                            requestCategory = category
                        } label: {
                            Image(systemName: "trash")
                        } //: BUTTON DELETE
                        .tint(.red)

                    }
                    
                } //: LOOP All Categories
                
            } //: LIST
            .navigationTitle("Categories")
            .overlay {
                if allCategories.isEmpty {
                    ContentUnavailableView {
                        Label("No Categories", systemImage: "tray.fill")
                    }
                }
            }
            /// New Category Add Button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        addCategory.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    })
                } //: TOOLBAR ADD BUTTON ITEM
            } //: TOOLBAR
            .sheet(isPresented: $addCategory, onDismiss: {
                categoryName = ""
            }, content: {
                NavigationStack {
                    
                    List {
                        
                        Section("Title") {
                            TextField("General", text: $categoryName)
                        } //: SECTION TITLE
                        
                    } //: LIST
                    .navigationTitle("Category Name")
                    .navigationBarTitleDisplayMode(.inline)
                    /// Add and Cancel buttons
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                addCategory = false
                            }
                            .tint(.red)
                        } //: TOOLBAR ITEM LEADING CANCEL
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add") {
                                /// Adding a new category
                                let category = Category(categoryName: categoryName)
                                context.insert(category)
                                
                                /// Closing View
                                categoryName = ""
                                addCategory = false
                            }
                            .disabled(categoryName.isEmpty)
                        } //: TOOLBAR ITEM TRAILING CANCEL
                        
                    } //: TOOLBAR ADD CATEGORY
                    
                } //: NAVIGATION
                .presentationDetents([.height(180)])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled()
            })
        } //: NAVIGATION
        .alert("If you delete a category, all the associated expenses will be deleted too.", isPresented: $deleteRequest) {
            Button(role: .destructive) {
                /// Deleting Category
                guard let requestCategory else { return }
                context.delete(requestCategory)
                self.requestCategory = nil
            } label: {
                Text("Delete")
            }
            
            Button(role: .cancel) {
                requestCategory = nil
            } label: {
                Text("Cancel")
            }

        } //: ALERT DELETE CATEGORY
    }
    
    
    /// Sorted categories by expenses count
    var sortedCategoriesByExpensesCount: [Category] {
        allCategories.sorted(by: {
            ($0.expanses?.count ?? 0) > ($1.expanses?.count ?? 0)
        })
    }
    
}

#Preview {
    CategoryView()
}
