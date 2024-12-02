//
//  ContentView.swift
//  Extract UIKit View from SwiftUI
//
//  Created by Matteo Buompastore on 02/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            /// Some views are native and don't contain any UIKit View
            /*Text("Hello, world!")
                .viewExtractor { view in
                    print(view)
                }*/
            /// Other views are UIKit views wrapped with SwiftUI Wrapper: TextField, Slider, List...
            /// 1,
            TextField("Hello World", text: .constant(""))
                .viewExtractor { view in
                    if let textField = view as? UITextField {
                        //print(textField)
                    }
                }
            
            /// 2,
            Slider(value: .constant(0.5))
                .viewExtractor { view in
                    if let slider = view as? UISlider {
                        slider.tintColor = .red
                        slider.thumbTintColor = .systemBlue
                    }
                }
            
            /// 3.
            List {
                Text("Hello View Extractor")
            }
            .viewExtractor { view in
                if let list = view as? UICollectionView {
                    //print(list)
                }
                if let scrollView = view as? UIScrollView {
                    //print(scrollView)
                    //scrollView.bounces = false
                }
            }
            
            /// Finally, some are UIViewControllers, NavigationStack, TabView...
            /// For those who can use next Property to extract controllers
            /*NavigationStack {
                List {
                    
                }
                .navigationTitle("Prova")
            }
            .viewExtractor { view in
                if let navController = view.next as? UINavigationController {
                    print(navController)
                }
            }*/
            
            /*TabView {
                
            }
            .viewExtractor { view in
                if let tabbarController = view.next as? UITabBarController {
                    tabbarController.tabBar.isHidden = true
                    print(tabbarController)
                }
            }*/
        }
        .padding()
    }
}

extension View {
    
    @ViewBuilder
    func viewExtractor(result: @escaping (UIView) -> Void) -> some View {
        self
            .background(ViewExtractorHelper(result: result))
            .compositingGroup()
    }
    
}

fileprivate struct ViewExtractorHelper: UIViewRepresentable {
    
    var result: (UIView) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            if let uikitView = view.superview?.superview?.subviews.last?.subviews.first {
                result(uikitView)
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

#Preview {
    ContentView()
}
