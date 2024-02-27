//
//  SegmentedControl.swift
//  Elastic Custom Segmented Control
//
//  Created by Matteo Buompastore on 27/02/24.
//

import SwiftUI

struct SegmentedControl<Indicator: View>: View {
    
    // MARK: - Proprties
    var tabs: [SegmentedTab]
    @Binding var activeTab: SegmentedTab
    var height: CGFloat = 45
    
    /// Whether to show tabs as Icons or Text
    var displayAsText: Bool = false
    var font: Font = .title3
    var activeTint: Color
    var inactiveTint: Color
    
    /// Indicator View
    @ViewBuilder var indicatorView: (CGSize) -> Indicator
    
    /// UI
    @State private var excessTabWidth: CGFloat = .zero
    @State private var minX: CGFloat = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let containerWidthEachForTab = size.width / CGFloat(tabs.count)
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.rawValue) { tab in
                    Group {
                        if displayAsText {
                            Text(tab.rawValue)
                        } else {
                            Image(systemName: tab.rawValue)
                        }
                    } //: Group
                    .font(font)
                    .foregroundStyle(activeTab == tab ? activeTint : inactiveTint)
                    .animation(.snappy, value: activeTab)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        if let index = tabs.firstIndex(of: tab),
                            let activeIndex = tabs.firstIndex(of: activeTab) {
                            self.activeTab = tab
                            withAnimation(.snappy(duration: 0.25, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                excessTabWidth = containerWidthEachForTab * CGFloat(index - activeIndex)
                                print(excessTabWidth)
                            } completion: {
                                withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                    minX = containerWidthEachForTab * CGFloat(index)
                                    excessTabWidth = 0
                                }
                            }
                        }
                    } //: On Tap
                    .background(alignment: .bottom) {
                        if tabs.first == tab {
                            GeometryReader {
                                let size = $0.size
                                
                                indicatorView(size)
                                    .frame(width: size.width + (excessTabWidth < 0 ? -excessTabWidth : excessTabWidth),
                                           height: size.height)
                                    .frame(width: size.width, alignment: excessTabWidth < 0 ? .trailing : .leading)
                                    .offset(x: minX)
                            }
                        }
                    } //: Background
                } //: Loop tabs
            }  //: HSTACK
            .preference(key: SizeKey.self, value: size)
            .onPreferenceChange(SizeKey.self) { size in
                if let index = tabs.firstIndex(of: activeTab) {
                    minX = containerWidthEachForTab * CGFloat(index)
                    excessTabWidth = 0
                }
            }
            
        } //: GEOMETRY
        .frame(height: height)
    }
}


fileprivate struct SizeKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
    
}


#Preview {
    @State var selectedTab: SegmentedTab = .home
    return SegmentedControl(
        tabs: SegmentedTab.allCases,
        activeTab: $selectedTab,
        height: 35,
        font: .body,
        activeTint: .white,
        inactiveTint: .gray.opacity(0.5)) { size in
            Rectangle()
                .fill(.blue)
                .frame(height: 4)
                .frame(maxHeight: .infinity, alignment: .bottom)
        } //: SEGMENTED CONTROL
}

#Preview {
    ContentView()
}
