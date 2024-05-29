//
//  ContentView.swift
//  TabView Offset Reader
//
//  Created by Matteo Buompastore on 29/05/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State private var activeTab: DummyTab = .home
    var offsetObserver = PageOffsetObserver()
    
    var body: some View {
        VStack(spacing: 15) {
            
            TabBar(.gray)
                .overlay {
                    if let collectionViewBounds = offsetObserver.collectionView?.bounds {
                        GeometryReader {
                            let width = $0.size.width
                            let tabCount = CGFloat(DummyTab.allCases.count)
                            let capsuleWidth = width / tabCount
                            let progress = offsetObserver.offset / collectionViewBounds.width
                            
                            Capsule()
                                .fill(.black)
                                .frame(width: capsuleWidth)
                                .offset(x: progress * capsuleWidth)
                            
                            TabBar(.white, .semibold)
                                .mask(alignment: .leading) {
                                    Capsule()
                                        .frame(width: capsuleWidth)
                                        .offset(x: progress * capsuleWidth)
                                }
                        } //: GEOMETRY
                    }
                }
                .background(.ultraThinMaterial)
                .clipShape(.capsule)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding([.horizontal, .top], 15)
            
            TabView(selection: $activeTab) {
                DummyTab.home.color
                    .tag(DummyTab.home)
                    .background {
                        if !offsetObserver.isObserving {
                            FindCollectionView {
                                offsetObserver.collectionView = $0
                                offsetObserver.observe()
                            }
                        }
                    }
                    
                DummyTab.chats.color
                    .tag(DummyTab.chats)
                DummyTab.calls.color
                    .tag(DummyTab.calls)
                DummyTab.settings.color
                    .tag(DummyTab.settings)
            } //: TABVIEW
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay {
                /*Text("\(offsetObserver.offset)")
                    .foregroundStyle(.white)*/
            }
        } //: VSTACK
    }
    
    
    //MARK: - Views
    
    @ViewBuilder
    private func TabBar(_ tint: Color, _ weight: Font.Weight = .regular) -> some View {
        HStack(spacing: 0) {
            ForEach(DummyTab.allCases, id: \.rawValue) { tab in
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(weight)
                    .foregroundStyle(tint)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                            activeTab = tab
                        }
                    }
            } //: Loop Tabs
        } //: HSTACK
    }
    
}

@Observable
class PageOffsetObserver: NSObject {
    var collectionView: UICollectionView?
    var offset: CGFloat = 0
    private(set) var isObserving: Bool = false
    
    deinit {
        remove()
    }
    
    func observe() {
        /// Safe Method
        guard !isObserving else { return }
        collectionView?.addObserver(self, forKeyPath: "contentOffset", context: nil)
        isObserving = true
    }
    
    func remove() {
        isObserving = false
        collectionView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    /// Not using delegate methods in order not to remove SwiftUI's default functionality by customizing delegate methods. So using the observe method instead.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else { return }
        if let contentOffset = (object as? UICollectionView)?.contentOffset {
            offset = contentOffset.x
        }
    }
    
}

struct FindCollectionView: UIViewRepresentable {
    
    var result: (UICollectionView) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let collectionView = view.collectionSuperView {
                result(collectionView)
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

extension UIView {
    
    /// Finding the CollectionView by trasversing the superview
    var collectionSuperView: UICollectionView? {
        if let collectionView = superview as? UICollectionView {
            return collectionView
        }
        return superview?.collectionSuperView
    }
    
}

#Preview {
    ContentView()
}
