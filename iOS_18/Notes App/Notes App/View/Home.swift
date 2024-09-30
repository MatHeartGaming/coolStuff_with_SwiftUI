//
//  Home.swift
//  Notes App
//
//  Created by Matteo Buompastore on 30/09/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: Properties
    @State private var searchText: String = ""
    @State private var selectedNote: Note?
    @State private var animateView: Bool = false
    @Namespace private var animation
    @State private var notes: [Note] = mockNotes
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                SearchBar()
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    ForEach($notes) { $note in
                        CardView(note)
                            .frame(height: 160)
                            .onTapGesture {
                                guard selectedNote == nil else { return }
                                
                                selectedNote = note
                                note.allowsHitTesting = true
                                withAnimation(noteAnimation) {
                                    animateView = true
                                }
                            }
                    } //: Loop Notes
                    
                } //: Lazy VGRID
                
            } //: VSTACK
        } //: V-SCROLL
        .safeAreaPadding(15)
        .overlay {
            GeometryReader { _ in
                /// This loop avoids weird effects when opening a new note while the previous one is still closing, confusing the matchedGeometry Effect.
                ForEach(notes) { note in
                    if note.id == selectedNote?.id, animateView {
                        DetailView(animation: animation, note: note)
                            .ignoresSafeArea(.container, edges: .top)
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomBar()
        }
    }
    
    
    // MARK: Views
    
    @ViewBuilder
    private func SearchBar() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
            
            TextField("Search", text: $searchText)
        } //: HSTACK
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color.primary.opacity(0.06), in: .rect(cornerRadius: 10))
    }
    
    @ViewBuilder
    private func CardView(_ note: Note) -> some View {
        ZStack {
            if selectedNote?.id == note.id && animateView {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(note.color.gradient)
                    .matchedGeometryEffect(id: note.id, in: animation)
            }
        }
    }
    
    @ViewBuilder
    private func BottomBar() -> some View {
        HStack(spacing: 15) {
            Button {
                
            } label: {
                Image(systemName: selectedNote == nil ? "plus.circle.fill" : "trash.fill")
                    .font(.title2)
                    .foregroundStyle(selectedNote == nil ? Color.primary : .red)
                    .contentShape(.rect)
                    .contentTransition(.symbolEffect(.replace))
            } //: Button Plus
            
            Spacer(minLength: 0)
            
            if selectedNote != nil {
                Button {
                    if let firstIndex = notes.firstIndex(where: { $0.id == selectedNote?.id }) {
                        notes[firstIndex].allowsHitTesting = false
                    }
                    withAnimation(noteAnimation) {
                        animateView = false
                        selectedNote = nil
                    }
                } label: {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.title3)
                        .foregroundStyle(Color.primary)
                        .contentShape(.rect)
                } //: Button Grid
                .transition(.opacity)
            }

        } //: HSTACK
        .overlay {
            Text("Notes")
                .font(.callout)
                .fontWeight(.semibold)
                .opacity(selectedNote != nil ? 0 : 1)
        }
        .overlay {
            if selectedNote != nil {
                CardColorPicker()
                    .transition(.blurReplace)
            }
        }
        .padding(15)
        .background(.bar)
        .animation(noteAnimation, value: selectedNote != nil)
    }
    
    @ViewBuilder
    private func CardColorPicker() -> some View {
        HStack(spacing: 10) {
            ForEach(1...5, id: \.self) { index in
                Circle()
                    .fill(.red.gradient)
                    .frame(width: 20, height: 20)
            }
        } //: HSTACK
    }
    
}

struct DetailView: View {
    
    var animation: Namespace.ID
    var note: Note
    
    /// UI
    @State private var animateLayers: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: animateLayers ? 0 : 10)
            .fill(note.color.gradient)
            .matchedGeometryEffect(id: note.id, in: animation)
        /// To remove the fade effect when the Detail View appears
            .transition(.offset(y: 1))
            .allowsTightening(note.allowsHitTesting)
            .onChange(of: note.allowsHitTesting, initial: true) { oldValue, newValue in
                withAnimation(noteAnimation) {
                    animateLayers = newValue
                }
            }
    }
    
}

extension View {
    var noteAnimation: Animation {
        .smooth(duration: 0.3, extraBounce: 0)
    }
}

#Preview {
    ContentView()
}
