//
//  CardView.swift
//  FlashCards Reorder and Drag
//
//  Created by Matteo Buompastore on 28/01/25.
//

import SwiftUI

struct FlashCardView: View {
    
    var card: FlashCard
    var category: Category
    @EnvironmentObject private var properties: DragProperties
    @Environment(\.managedObjectContext) private var context
    
    /// UI
    @GestureState private var isActive: Bool = false
    @State private var haptics: Bool = false
    
    var body: some View {
        GeometryReader {
            let rect = $0.frame(in: .global)
            let isSwappingInSameGroup = rect.contains(properties.location) && properties.sourceCard != card && properties.destinationCategory == nil
            
            Text(card.title ?? "")
                .padding(.horizontal, 15)
                .frame(width: rect.width, height: rect.height, alignment: .leading)
                .background(Color("Background"), in: .rect(cornerRadius: 10))
                .gesture(customGesture(rect: rect))
                .onChange(of: isSwappingInSameGroup) { oldValue, newValue in
                    if newValue {
                        print("Swap", card.title ?? "", properties.sourceCard?.title ?? "")
                        properties.swapCardsInSameGroup(card)
                    }
                }
            
        }
         //: GEOMETRY
        .frame(height: 60)
        /// Hiding the active dragging view
        .opacity(properties.sourceCard == card ? 0 : 1)
        .onChange(of: isActive) { oldValue, newValue in
            if newValue {
                haptics.toggle()
            } else {
                handleGestureEnd()
            }
        }
        .sensoryFeedback(.impact, trigger: haptics)
    }
    
    
    // MARK: Functions
    
    private func customGesture(rect: CGRect) -> some Gesture {
        LongPressGesture(minimumDuration: 0.3)
            .sequenced(before: DragGesture(coordinateSpace: .global))
            .updating($isActive, body: { _, out, _ in
                out = true
            })
            .onChanged { value in
                /// This means LongGesture has finished and the DragGesture has begun!
                if case .second(_, let gesture) = value {
                    handleGestureChange(gesture, rect: rect)
                }
            }
    }
    
    private func handleGestureChange(_ gesture: DragGesture.Value?, rect: CGRect) {
        /// Step 1: Create a preview of the dragged view
        if properties.previewImage == nil {
            properties.show = true
            properties.previewImage = createPreviewImage(rect)
            /// Storing source properties
            properties.sourceCard = card
            properties.sourceCategory = category
            properties.initalViewLocation = rect.origin
        }
        
        guard let gesture else { return }
        
        properties.offset = gesture.translation
        properties.location = gesture.location
        properties.updatedViewLocation = rect.origin
    }
    
    private func handleGestureEnd() {
        withAnimation(.easeInOut(duration: 0.25), completionCriteria: .logicallyComplete) {
            if properties.destinationCategory != nil {
                properties.changeGroup(context)
            } else {
                /// Updating View location
                if properties.updatedViewLocation != .zero {
                    properties.initalViewLocation = properties.updatedViewLocation
                }
                properties.offset = .zero
            }
        } completion: {
            /// Saving changes
            if properties.isCardsSwapped {
                try? context.save()
            }
            
            properties.resetAllProperties()
        }
    }
    
    private func createPreviewImage(_ rect: CGRect) -> UIImage? {
        let view = HStack {
            Text(card.title ?? "")
                .padding(.horizontal, 15)
                .foregroundStyle(.white)
                .frame(width: rect.width, height: rect.height, alignment: .leading)
                .background(Color("Background"), in: .rect(cornerRadius: 10))
        }
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
    
}

#Preview("Content View") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
