//
//  ContentView.swift
//  Custom In app Notifications
//
//  Created by Matteo Buompastore on 20/02/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheet = false
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                Button("Show Sheet") {
                    showSheet.toggle()
                }
                .sheet(isPresented: $showSheet) {
                    Button("Show AirDrop Notification") {
                        UIApplication.shared.inAppNotification(adaptForDynamicIsland: true, timeout: 5, swipeToClose: true) {
                            HStack {
                                Image(systemName: "wifi")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("AirDrop")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                    
                                    Text("From Leon S. Kennedy")
                                        .textScale(.secondary)
                                        .foregroundStyle(.gray)
                                } //: VSTACK
                                .padding(.top, 20)
                                
                                Spacer(minLength: 0)
                                
                            } //: HSTACK
                            .padding(15)
                            .background(.black, in: .rect(cornerRadius: 15, style: .continuous))
                        }
                    }
                }
                
                Button("Show Notification") {
                    UIApplication.shared.inAppNotification(adaptForDynamicIsland: true, timeout: 5, swipeToClose: true) {
                        HStack {
                            Image(.pic)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(.circle)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Leon S. Kennedy")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                
                                Text("Hello, it's Leon S. Kennedy!")
                                    .textScale(.secondary)
                                    .foregroundStyle(.gray)
                            } //: VSTACK
                            .padding(.top, 20)
                            
                            Spacer(minLength: 0)
                            
                            Button(action: {}, label: {
                                Image(systemName: "speaker.slash.fill")
                                    .font(.title2)
                            })
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                            .tint(.white)
                            
                        } //: HSTACK
                        .padding(15)
                        .background(.black, in: .rect(cornerRadius: 15, style: .continuous))
                    }
                } //: Notification Button
            } //: VSTACK
            .navigationTitle("In App Notifications")
            
        } //: NAVIGATION
    }
}

#Preview {
    ContentView()
}
