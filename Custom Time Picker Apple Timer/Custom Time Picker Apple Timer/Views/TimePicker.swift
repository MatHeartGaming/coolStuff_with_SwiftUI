//
//  TimePicker.swift
//  Custom Time Picker Apple Timer
//
//  Created by Matteo Buompastore on 28/06/24.
//

import SwiftUI

struct TimePicker: View {
    
    // MARK: - Properties
    var style: AnyShapeStyle = .init(.bar)
    @Binding var hour: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    var hoursRange: ClosedRange<Int> = 0...24
    var minutesRange: ClosedRange<Int> = 0...60
    var secondsRange: ClosedRange<Int> = 0...60
    
    var body: some View {
        HStack(spacing: 0) {
            CustomView("hours", hoursRange, $hour)
            CustomView("mins", minutesRange, $minutes)
            CustomView("secs", secondsRange, $seconds)
        }
        .offset(x: -25)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(style)
                .frame(height: 35)
        }
    }
    
    
    //MARK: - Views
    
    @ViewBuilder private func CustomView(_ title: String, _ range: ClosedRange<Int>, _ selection: Binding<Int>) -> some View {
        PickerViewWithoutIndicator(selection: selection) {
            ForEach(range, id: \.self) { value in
                Text("\(value)")
                    .frame(width: 35, alignment: .trailing)
                    .tag(value)
            } //: Loop hours
        }
        .overlay {
            Text(title)
                .font(.callout)
                .frame(width: 50, alignment: .leading)
                .lineLimit(1)
                .offset(x: 50)
        }
    }
}


struct PickerViewWithoutIndicator<Content: View, Selection: Hashable>: View {
    
    @Binding var selection: Selection
    @ViewBuilder var content: Content
    
    @State private var isHidden: Bool = false
    
    var body: some View {
        Picker("", selection: $selection) {
            if !isHidden {
                RemovePickerIndicator {
                    isHidden = true
                }
            } else {
                content
            }
        }
        .pickerStyle(.wheel)
    }
}


/// To remove background form Picker
fileprivate struct RemovePickerIndicator: UIViewRepresentable {
    
    var result: () -> Void
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let pickerView = view.pickerView {
                /// The second subview contained the background for the UIPicker VIew
                if pickerView.subviews.count >= 2 {
                    pickerView.subviews[1].backgroundColor = .clear
                }
                result()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

extension UIView {
    var pickerView: UIPickerView? {
        if let view = superview as? UIPickerView {
            return view
        }
        return superview?.pickerView
    }
}


#Preview {
    TimePicker(hour: .constant(0), minutes: .constant(0), seconds: .constant(0))
}
