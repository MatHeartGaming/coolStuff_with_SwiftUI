//
//  Home.swift
//  Interactive Charts
//
//  Created by Matteo Buompastore on 08/01/24.
//

import SwiftUI
import Charts

struct Home: View {
    
    // MARK: - UI
    @State private var graphType: GraphType = .bar
    
    /// Chart selection
    @State private var barSelection: String?
    @State private var pieSelection: Double?
    
    var body: some View {
        VStack {
            
            /// Segmented Picker
            Picker("", selection: $graphType) {
                ForEach(GraphType.allCases, id: \.rawValue) {type in
                    Text(type.rawValue)
                        .tag(type)
                } //: LOOP CHART TYPEs
            } //: PICKER
            .pickerStyle(.segmented)
            .labelsHidden()
            
            ZStack {
                if let highestDownloads = appDownloads.max(by: { $1.downloads > $0.downloads }) {
                    if graphType == .bar {
                        ChartPopoverView(highestDownloads.downloads, highestDownloads.month, isTitleView: true)
                            .opacity(barSelection == nil ? 1 : 0)
                    } else {
                        if let barSelection,
                           let selectedDownloads = downloadList.findDownloads(barSelection) {
                            ChartPopoverView(selectedDownloads, 
                                             barSelection,
                                             isTitleView: true,
                                             isSelected: true)
                        } else {
                            ChartPopoverView(highestDownloads.downloads,
                                             highestDownloads.month,
                                             isTitleView: true)
                        }
                    }
                }
            } //: ZSTACK
            .padding(.vertical)
            
            /// Charts
            Chart {
                ForEach(downloadList) { downlaod in
                    if graphType == .bar {
                        /// Bar chart
                        BarMark(
                            x: .value("Month", downlaod.month),
                            y: .value("Downloads", downlaod.downloads)
                        )
                        .cornerRadius(8)
                        .foregroundStyle(by: .value("Month", downlaod.month))
                    } else {
                        /// New API
                        /// Pie/Donut Chart
                        
                        SectorMark(angle: .value("Downloads", downlaod.downloads),
                                   innerRadius: .ratio(graphType == .donut ? 0.6 : 0), // <-- this is the radius of the donut (The circle in the middle)
                                   angularInset: graphType == .donut ? 6 : 1 // <-- Spacing between pie slices
                        )
                        .cornerRadius(8)
                        .foregroundStyle(by: .value("Month", downlaod.month))
                        /// Fading out all other content, expect for the current selection
                        .opacity(barSelection == nil ? 1 : (barSelection == downlaod.month ? 1 : 0.4))
                        
                    }
                } //: LOOP DOWNLOADS
                
                if let barSelection {
                    RuleMark(x: .value("Month", barSelection))
                        .foregroundStyle(.gray.opacity(0.35))
                        .zIndex(-10)
                        .offset(yStart: -10)
                        .annotation(
                            position: .top, 
                            spacing: 0,
                            overflowResolution: .init(x: .fit, y: .disabled)) {
                                if let downlaods = appDownloads.findDownloads(barSelection) {
                                    ChartPopoverView(downlaods, barSelection)
                                }
                            }
                }
            } //: CHART
            /// This allows us to capture chart selection and give chart ranges (iOS 17+ only)
            .chartXSelection(value: $barSelection)
            .chartAngleSelection(value: $pieSelection)
            .chartLegend(position: .bottom, alignment: graphType == .bar ? .leading : .center, spacing: 25)
            .frame(height: 300)
            .padding(.top, 10)
            .animation(.snappy, value: graphType)
            
            Spacer(minLength: 0)
            
        } //: VSTACK
        .padding()
        .onChange(of: pieSelection, initial: false) { oldValue, newValue in
            if let newValue {
                findDownload(newValue)
            } else {
                barSelection = nil
            }
        }
    }
    
    
    // MARK: - VIEWS
    
    @ViewBuilder
    func ChartPopoverView(_ downloads: Double, _ month: String, isTitleView: Bool = false, isSelected: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(isTitleView && !isSelected ? "Highest" : "App") Downloads")
                .font(.title3)
                .foregroundStyle(.gray)
            
            HStack(spacing: 4) {
                Text(String(format: "%.0f", downloads))
                    .fontWeight(.semibold)
                
                Text(month)
                    .textScale(.secondary)
                
            } //: HSTACK
            .font(.title3)
            
            
            
        } //: VSTACK
        .padding(isTitleView ? [.horizontal] : [.all])
        .background(Color("PopupColor").opacity(isTitleView ? 0 : 1),
                    in: .rect(cornerRadius: 8))
        .frame(maxWidth: .infinity, alignment: isTitleView ? .leading : .center)
    }
    
    
    //MARK: - FUNCTIONS
    
    func findDownload(_ rangeValue: Double) {
        var initalValue: Double = 0
        let convertedArray = downloadList.compactMap { download -> (String, Range<Double>) in
            let rangeEnd = initalValue + download.downloads
            let tuple = (download.month, initalValue..<rangeEnd)
            /// Updating inital value for next iteration
            initalValue = rangeEnd
            return tuple
        }
        
        /// Find the value in the range
        if let downlaod = convertedArray.first(where: { $0.1.contains(rangeValue) }) {
            /// Update selection
            barSelection = downlaod.0
        }
    }
    
    
    //MARK: - Other computed variables
    
    var downloadList: [AppDownload] {
        graphType == .bar ? appDownloads : appDownloadsSortedAscending
    }
    
}

#Preview {
    Home()
}
