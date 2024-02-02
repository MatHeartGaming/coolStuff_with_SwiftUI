//
//  ContentView.swift
//  Universal Hero Effect
//
//  Created by Matteo Buompastore on 02/02/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showView = false
    
    var body: some View {
        /*NavigationStack {
            VStack {
                SourceView(id: "View 1") {
                    Circle()
                        .fill(.red)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            showView.toggle()
                        }
                } //: SOURCE VIEW
            } //: VSTACK
            .padding()
            .navigationTitle("Hero Animation")
            .navigationDestination(isPresented: $showView) {
                DestinationView(id: "View 1") {
                    Circle()
                        .fill(.red)
                        .frame(width: 150, height: 150)
                        .onTapGesture {
                            showView.toggle()
                        }
                } //: DEST VIEW
                .padding(15)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                /// When using Hero you must disable all native dismiss actions!!!
                .interactiveDismissDisabled()
                .navigationBarBackButtonHidden()
                .navigationTitle("Hero Detail View")
            }
        } //: NAVIGATION
        /*.fullScreenCover(isPresented: $showView, content: {
            DestinationView(id: "View 1") {
                Circle()
                    .fill(.red)
                    .frame(width: 150, height: 150)
                    .onTapGesture {
                        showView.toggle()
                    }
            } //: DEST VIEW
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            /// When using Hero you must disable all native dismiss actions!!!
            .interactiveDismissDisabled()
        })*/
        .heroLayer(id: "View 1", animate: $showView) {
            Circle()
                .fill(.red)
        } completion: { status in
            
        }*/
        
        DemoHeroUsage()

    }
}

struct DemoHeroUsage: View {
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    CardView(item: item)
                }
            }
            .navigationTitle("Hero Effect")
        }
    }
    
}

struct CardView: View {
    
    var item: Item
    @State private var expandSheet: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            SourceView(id: item.id.uuidString) {
                ImageView()
            }
            
            Text(item.title)
            
            Spacer(minLength: 0)
        }
        .contentShape(.rect)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onTapGesture {
            expandSheet.toggle()
        }
        .sheet(isPresented: $expandSheet, content: {
            DestinationView(id: item.id.uuidString) {
                ImageView(size: 100)
                    .onTapGesture {
                        expandSheet = false
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
            .interactiveDismissDisabled()
        })
        .heroLayer(id: item.id.uuidString, animate: $expandSheet) {
            ImageView(size: 100)
        } completion: { status in
            
        }

    }
    
    @ViewBuilder
    func ImageView(size: CGFloat = 40) -> some View {
        Image(systemName: item.symbol)
            .font(.title2)
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(item.color.gradient, in: .circle)
    }
    
}

#Preview {
    HeroWrapper {
        ContentView()
    }
}
