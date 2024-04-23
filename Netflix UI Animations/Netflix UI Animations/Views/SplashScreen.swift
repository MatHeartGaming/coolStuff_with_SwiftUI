//
//  SplashScreen.swift
//  Netflix UI Animations
//
//  Created by Matteo Buompastore on 19/04/24.
//

import SwiftUI
import Lottie

struct SplashScreen: View {
    
    //MARK: - Properties
    @Environment(AppData.self) private var appData
    @State private var progress: CFloat = 0
    
    var body: some View {
        Rectangle()
            .fill(.black)
            .overlay {
                if let jsonURL {
                    LottieView {
                        await LottieAnimation.loadedFrom(url: jsonURL)
                    }
                    .playing(.fromProgress(0, toProgress: AnimationProgressTime(progress), loopMode: .playOnce))
                    .animationDidFinish({ completed in
                        appData.isSplashFinished = progress != 0 && completed
                        appData.showProfileView = appData.isSplashFinished
                        appData.hideMainView = appData.showProfileView
                    })
                    /// To make ti look good on all iPhone screen sizes
                    .frame(width: 600, height: 400)
                    .task {
                        try? await Task.sleep(for: .seconds(0.15))
                        progress = 0.8
                    }
                }
            } //: RECTANGLE
            .ignoresSafeArea()
    }
    
    private var jsonURL: URL? {
        if let bundlePath = Bundle.main.path(forResource: "Logo", ofType: "json") {
            return URL(filePath: bundlePath)
        }
        return nil
    }
    
}

#Preview {
    SplashScreen()
        .preferredColorScheme(.dark)
        .environment(AppData())
}

#Preview {
    ContentView()
        .environment(AppData())
        .preferredColorScheme(.dark)
}
