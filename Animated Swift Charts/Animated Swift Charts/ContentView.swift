//
//  ContentView.swift
//  Animated Swift Charts
//
//  Created by Matteo Buompastore on 08/04/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    //MARK: - Properties
    @State private var appDownloads: [Download] = sampleDownloads
    @State private var isAnimated: Bool = false
    @State private var trigger: Bool = false
    @State private var chartSelection: ChartType = .line
    
    var body: some View {
        NavigationStack {
            VStack {
                Chart {
                    ForEach(appDownloads) { download in
                        SectorMark(angle: .value("Downloads", download.isAnimated ? download.value : 0))
                            .foregroundStyle(by: .value("Month", download.month))
                            .opacity(download.isAnimated ? 1 : 0)
                    }
                }
                .chartYScale(domain: 0...12000)
                .frame(height: 250)
                .padding()
                .background(.background, in: .rect(cornerRadius: 10))
                
                Spacer()
            } //: VSTACK
            .padding()
            .background(.gray.opacity(0.12))
            .navigationTitle("Animated Charts")
            .onAppear(perform: animateChart)
            .onChange(of: trigger) { oldValue, newValue in
                resetChartAnimation()
                animateChart()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Trigger") {
                        appDownloads.append(contentsOf: [
                            .init(date: .createDate(1, 2, 23), value: 4700),
                            .init(date: .createDate(9, 3, 23), value: 9720),
                            .init(date: .createDate(10, 4, 23), value: 1400),
                        ])
                        trigger.toggle()
                    }
                }
            }
            
        } //: NAVIGATION
    }
    
    //MARK: - Views
    
    @ViewBuilder
    private func PieChart() -> some View {
        Chart {
            ForEach(appDownloads) { download in
                SectorMark(angle: .value("Downloads", download.isAnimated ? download.value : 0))
                    .foregroundStyle(by: .value("Month", download.month))
                    .opacity(download.isAnimated ? 1 : 0)
            }
        }
        .chartYScale(domain: 0...12000)
        .frame(height: 250)
        .padding()
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    private func BarChart() -> some View {
        Chart {
            ForEach(appDownloads) { download in
                BarMark(
                    x: .value("Month", download.month),
                    y: .value("Downalods", download.isAnimated ? download.value : 0)
                )
                .foregroundStyle(.red.gradient)
                .opacity(download.isAnimated ? 1 : 0)
            }
        }
        .chartYScale(domain: 0...12000)
        .frame(height: 250)
        .padding()
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    private func LineChart() -> some View {
        Chart {
            ForEach(appDownloads) { download in
                LineMark(
                    x: .value("Month", download.month),
                    y: .value("Downalods", download.isAnimated ? download.value : 0)
                )
                .foregroundStyle(.red.gradient)
                .opacity(download.isAnimated ? 1 : 0)
            }
        }
        .chartYScale(domain: 0...12000)
        .frame(height: 250)
        .padding()
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    
    //MARK: - Functions
    
    private func animateChart() {
        guard !isAnimated else { return }
        isAnimated = true
        $appDownloads.enumerated().forEach { index, element in
            /// To avoid animating large set of data after a certain index
            if index > 5 {
                element.wrappedValue.isAnimated = true
            } else {
                let delay = Double(index) + 0.05
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.smooth) {
                        element.wrappedValue.isAnimated = true
                    }
                }
            }
        }
    }
    
    private func resetChartAnimation() {
        $appDownloads.forEach { download in
            download.wrappedValue.isAnimated = false
        }
        isAnimated = false
    }
    
    
    
}

#Preview {
    ContentView()
}
