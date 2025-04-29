//
//  ContentView.swift
//  CustomScrollIndicator
//
//  Created by Matteo Buompastore on 29/04/25.
//

import SwiftUI

struct ContactsSection: Identifiable {
    let id: String
    let contacts: [Contact]
    
    static func generateData() -> [ContactsSection] {
        Dictionary(grouping: dummyContacts) {
            String($0.name.first ?? "A")
        }.compactMap({ .init(id: $0.key, contacts: $0.value) })
            .sorted {
                $0.id < $1.id
            }
    }
}

struct ContentView: View {
    
    // MARK: Properties
    @State private var sections: [ContactsSection] = ContactsSection.generateData()
    
    /// Scroll Properties
    @State private var scrollProperties: ScrollGeometry = .init(
        contentOffset: .zero,
        contentSize: .zero,
        contentInsets: .init(),
        containerSize: .zero
    )
    @State private var scrollPhase: ScrollPhase = .idle
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var activeID: String = "A"
    
    /// Gesture
    @State private var previousScrollProgress: CGFloat?
    @GestureState private var isGestureActive: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 12) {
                    ForEach(sections) { section in
                        SectionView(section)
                    } //: Loop Sections
                } //: VSTACK
                .padding(20)
                .padding(.bottom, scrollProperties.containerSize.height - 150)
            } //: SCROLL
            .background(.gray.opacity(0.15))
            .navigationTitle("Contacts")
            .scrollIndicators(.hidden)
            .onScrollGeometryChange(for: ScrollGeometry.self) {
                $0
            } action: { oldValue, newValue in
                scrollProperties = newValue
            }
            .onScrollPhaseChange { oldPhase, newPhase in
                scrollPhase = newPhase
            }
            .scrollPosition($scrollPosition)

        }
        .overlay(alignment: .trailing) {
            CustomScrollindicator()
        }
    }
    
    @ViewBuilder
    private func SectionView(_ section: ContactsSection) -> some View {
        VStack {
            Text(section.id)
                .font(.largeTitle.bold())
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(section.contacts) { contact in
                    Text(contact.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if contact.id != section.contacts.last?.id {
                        Divider()
                    }
                } //: Loop
            } //: VSTACK
        } //: VSTACK
        .padding(15)
        .background(.background, in: .rect(cornerRadius: 10))
        .onGeometryChange(for: CGRect.self) {
            $0.frame(in: .scrollView(axis: .vertical))
        } action: { newValue in
            if newValue.minY >= 0 && newValue.minY < 150 {
                activeID = section.id
            }
        }

    }
    
    @ViewBuilder
    private func CustomScrollindicator() -> some View {
        GeometryReader { geometry in
            let indicatorHeight: CGFloat = 40
            
            /// Progress (0-1)
            let scrollProgress = max(min(scrollProperties.scrollOffsetY / scrollProperties.contentHeight, 1), 0)
            
            /// Indicator Offset
            let indicatorOffset = (geometry.size.height - indicatorHeight) * scrollProgress
            
            let showPopUp: Bool = scrollPhase != .idle || isGestureActive
            
            ZStack(alignment: .top) {
                Capsule()
                    .fill(.background.shadow(.drop(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)))
                    .padding(.trailing, 5)
                
                Capsule()
                    .fill(.blue.gradient)
                    .frame(height: indicatorHeight)
                    .padding(.trailing, 5)
                    .contentShape(.rect)
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .named("INDICATORVIEW"))
                            .updating($isGestureActive, body: { _, out, _ in
                                out = true
                            })
                            .onChanged { value in
                                
                                if previousScrollProgress == nil {
                                    previousScrollProgress = scrollProgress
                                }
                                
                                guard let previousScrollProgress else { return }
                                
                                /// Calculating Drag progress
                                let dragProgress = value.translation.height / (geometry.size.height - indicatorHeight)
                                let endProgress = max(min(previousScrollProgress + dragProgress, 1), 0)
                                
                                /// Scroll Content
                                scrollPosition.scrollTo(y: endProgress * scrollProperties.contentHeight)
                                
                            }
                    )
                    .offset(y: indicatorOffset)
                    .onChange(of: isGestureActive) { oldValue, newValue in
                        if !newValue {
                            previousScrollProgress = nil
                        }
                    }
            } //: ZSTACK
            .overlay(alignment: .topLeading) {
                ZStack {
                    if showPopUp {
                        UnevenRoundedRectangle(
                            topLeadingRadius: 50,
                            bottomLeadingRadius: 50,
                            bottomTrailingRadius: 5,
                            topTrailingRadius: 50,
                            style: .continuous
                        )
                        .fill(.blue.gradient)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Text(activeID)
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        }
                        .compositingGroup()
                        .offset(x: -55, y: indicatorOffset - 10)
                    }
                } //: ZSTACK
                .offset(y: isGestureActive ? -50 : 0)
                .animation(.easeInOut(duration: 0.25), value: isGestureActive)
            }
            .animation(.easeInOut(duration: 0.25), value: showPopUp)
        } //: GEOMETRY
        .frame(width: 13)
        .containerRelativeFrame(.vertical) { value, _ in
            value * 0.5
        }
        .coordinateSpace(.named("INDICATORVIEW"))
    }
    
}

#Preview {
    ContentView()
}


extension ScrollGeometry {
    var scrollOffsetY: CGFloat {
        contentOffset.y + contentInsets.top
    }
    
    var contentHeight: CGFloat {
        contentSize.height - containerSize.height
    }
}
