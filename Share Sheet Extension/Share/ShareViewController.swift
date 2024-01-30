//
//  ShareViewController.swift
//  Share
//
//  Created by Matteo Buompastore on 30/01/24.
//

import UIKit
import Social
import SwiftUI
import SwiftData

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .red
        
        /// Interactive Dismiss Disabled
        isModalInPresentation = true
        
        if let extensionContext = extensionContext,
           let itemProvider = (extensionContext.inputItems.first as? NSExtensionItem)?.attachments {
            let hostingView = UIHostingController(rootView: ShareView(itemProvider: itemProvider,
                                                                      extensionContext: extensionContext))
            hostingView.view.frame = view.frame
            view.addSubview(hostingView.view)
        }
        
        
    }

}

fileprivate struct ShareView: View {
    
    //MARK: - Properties
    var itemProvider: [NSItemProvider]
    var extensionContext: NSExtensionContext?
    
    /// UI
    @State private var items: [Item] = []
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            VStack(spacing: 15) {
                Text("Add to Favourites")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Button("Cancel", action: dismiss)
                            .tint(.red)
                    }
                    .padding(.bottom, 10)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(items) { item in
                            
                            Image(uiImage: item.previewImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: size.width - 30)
                            
                        } //: Loop Image Items
                    } //: Lazy HStack
                    .padding(.horizontal, 15)
                    .scrollTargetLayout()
                } // H-SCROLL
                .scrollTargetBehavior(.viewAligned)
                .frame(height: 300)
                
                /// Save Button
                Button(action: saveItems, label: {
                    Text("Save")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.blue, in: .rect(cornerRadius: 10, style: .continuous))
                        .contentShape(.rect)
                })
                
                Spacer(minLength: 0)
            } //: VSTACK
            .padding(15)
            .onAppear {
                extractItems(size: size)
            }
        } //: GEOMETRY
    }
    
    
    //MARK: - Functions
    
    private func extractItems(size: CGSize) {
        guard items.isEmpty else { return }
        DispatchQueue.global(qos: .userInteractive).async {
            for provider in itemProvider {
                let _ = provider.loadDataRepresentation(for: .image) { data, error in
                    if let data, let image = UIImage(data: data),
                       let thumbnail = image.preparingThumbnail(of: .init(width: size.width, height: 300)) {
                        /// UI updated on Main Thread
                        DispatchQueue.main.async {
                            items.append(.init(imageData: data, previewImage: thumbnail))
                        }
                    }
                }
            }
        }
    }
    
    private func saveItems() {
        do {
            let context = try ModelContext(.init(for: ImageItem.self))
            /// Saving
            for item in items {
                context.insert(ImageItem(data: item.imageData))
            }
            
            try context.save()
            
            /// Close view
            dismiss()
        } catch {
            print(error.localizedDescription)
            dismiss()
        }
    }
    
    private func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
    
    
    private struct Item: Identifiable {
        let id = UUID()
        var imageData: Data
        var previewImage: UIImage
    }
    
}
