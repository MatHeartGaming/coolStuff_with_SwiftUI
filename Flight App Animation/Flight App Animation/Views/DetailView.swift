//
//  DetailView.swift
//  Flight App Animation
//
//  Created by Matteo Buompastore on 15/02/24.
//

import SwiftUI

struct DetailView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    var size: CGSize
    var safeArea: EdgeInsets
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack {
                    Image(.logo)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .scaledToFit()
                        .frame(width: 100)
                    
                    Text("Your order has been submitted")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.top, 10)
                    
                    Text("We are waiting for the booking confirmation")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                } //: VSTACK
                .frame(maxWidth: .infinity)
                .padding(.top, 30)
                .padding(.bottom, 40)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.white.opacity(0.1))
                }
                
                HStack {
                    FlightDetailsView(place: "Napoli", code: "NAC", timing: "24 Jul, 11:00")
                    
                    VStack(spacing: 8) {
                        
                        Image(systemName: "chevron.right")
                            .font(.title2)
                        
                        Text("2h 25m")
                        
                    } //: VSTACK
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    
                    FlightDetailsView(alignment: .trailing, place: "Dublin", code: "DUB", timing: "24 Jul, 13:25")
                } //: HSTACK
                .padding(15)
                .padding(.bottom, 70)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .padding(.top, -20)
                
            } //: VSTACK
            .padding(.horizontal, 20)
            .padding(.top, safeArea.top + 15)
            .padding([.horizontal, .bottom], 15)
            .background {
                Rectangle()
                    .fill(.blueTop)
                    .padding(.bottom, 80)
            }
            
            /// Contact Info View
            GeometryReader { proxy in
                /// For smaller device adaptation
                ViewThatFits {
                    ContactInformation()
                    ScrollView(.vertical) {
                        ContactInformation()
                    }
                    .scrollIndicators(.hidden)
                }
            }
            
        } //: VSTACK
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private func ContactInformation() -> some View {
        VStack(spacing: 15) {
            HStack {
                InfoView(title: "Flight", subtitle: "AR 580")
                InfoView(title: "Class", subtitle: "Premium")
                InfoView(title: "Aircraft", subtitle: "B 737-900")
                InfoView(title: "Possibility", subtitle: "AR 580")
            } //: HSTACK
            
            ContactView(name: "Leon S. Kennedy", email: "mat@gmail.com", profile: "User 1")
                .padding(.top, 30)
            
            ContactView(name: "Ada Rondinone", email: "therondinon@gmail.com", profile: "User 2")
                .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Price")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                
                Text("€320.00")
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
            } //: VSTACK
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.leading, 15)
            
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Go To Home Screen")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .fill(.blueTop.gradient)
                    }
            }) //: Go To Home Button
            .padding(.top, 15)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, safeArea.bottom)
            
        } //: VSTACK
        .padding(15)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private func ContactView(name: String, email: String, profile: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                
                Text(email)
                    .font(.callout)
                    .foregroundStyle(.gray)
            } //: VSTACK
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(profile)
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
                .clipShape(.circle)
            
        } //: HSTACK
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    private func InfoView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
            
            Text(subtitle)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity)
    }
    
}

#Preview {
    GeometryReader {
        let size = $0.size
        let safeArea = $0.safeAreaInsets
        DetailView(size: size, safeArea: safeArea)
            .ignoresSafeArea(.container)
    }
}

#Preview {
    ContentView()
}
