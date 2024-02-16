//
//  MusicInfo.swift
//  Apple Music Bottom Sheet Animation
//
//  Created by Matteo Buompastore on 16/02/24.
//

import SwiftUI

struct MusicInfo: View {
    
    //MARK: - Properties
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    
    var body: some View {
        HStack {
            /// Matched Geometry Effect
            ZStack {
                if !expandSheet {
                    GeometryReader {
                        let size = $0.size
                        
                        Image(.artwork)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width, height: size.height)
                            .clipShape(.rect(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
                    } //: GEOMETRY
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                }
            } //: ZSTACK
            .frame(width: 45, height: 45)
            
            Text("Charlie Brown")
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 15)
            
            Spacer(minLength: 0)
            
            Button("", systemImage: "pause.fill") {
                
            }
            .font(.title2)
            
            Button("", systemImage: "forward.fill") {
                
            }
            .font(.title2)
            .padding(.leading, 25)

            
        } //: HSTACK
        .foregroundStyle(.primary)
        .padding(.horizontal)
        .padding(.bottom, 5)
        .frame(height: 70)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
    }
}

#Preview {
    @State var expand: Bool = false
    @Namespace var animation

    let view = MusicInfo(expandSheet: $expand, animation: animation)
        .preferredColorScheme(ColorScheme.dark)
    return view
}

#Preview {
    Home()
        .preferredColorScheme(.dark)
}
