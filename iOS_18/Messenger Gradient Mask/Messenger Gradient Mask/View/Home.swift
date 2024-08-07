//
//  Home.swift
//  Messenger Gradient Mask
//
//  Created by Matteo Buompastore on 07/08/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    ForEach(messages) { message in
                        MessageCardView(screenProxy: proxy, message: message)
                    }
                    //MessageCardView(screenProxy: proxy, message: messages.first!)
                } //: Lazy VSTACK
                .padding(15)
            } //: SCROLL
        } //: GEOMETRY
    }
}

struct MessageCardView: View {
    
    var screenProxy: GeometryProxy
    var message: Message
    
    var body: some View {
        Text(message.message)
            .padding(10)
            .foregroundStyle(message.isReply ? Color.primary : .white)
            .background {
                if message.isReply {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                } else {
                    GeometryReader {
                        let actualSize = $0.size
                        let rect = $0.frame(in: .global)
                        let screenSize = screenProxy.size
                        let safeArea = screenProxy.safeAreaInsets
                        
                        let safeAreaTop = safeArea.top
                        let safeAreaBottom = safeArea.bottom
                        let safeAreaTopBottom = safeAreaTop + safeAreaBottom
                        
                        Rectangle()
                            .fill(
                                .linearGradient(colors: [
                                    Color("C1"),
                                    Color("C2"),
                                    Color("C3"),
                                    Color("C3"),
                                    Color("C4"),
                                    Color("C4"),
                                ], startPoint: .top, endPoint: .bottom))
                            .mask(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: actualSize.width, height: actualSize.height)
                                    .offset(x: rect.minX, y: rect.minY)
                            }
                            .offset(x: -rect.minX, y: -rect.minY)
                            .frame(width: screenSize.width, 
                                   height: screenSize.height + safeAreaTopBottom)
                    } //: Geometry
                }
            }
            .frame(maxWidth: 250, alignment: message.isReply ? .leading : .trailing)
            .frame(maxWidth: .infinity, alignment: message.isReply ? .leading : .trailing)
    }
    
}

#Preview {
    Home()
}

#Preview("Content View") {
    ContentView()
}
