//
//  BIGIApp.swift
//  BIGI
//
//  Created by Dongwan Ryoo on 10/9/25.
//

import SwiftUI
import AppTrackingTransparency

@main
struct BIGIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ForEach(Tap.allCases) { tap in
                    Tab(
                        tap.description,
                        systemImage: tap.systemImage,
                        content: {tap.content}
                    )
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    setUpTrackingAuthorization()
                }
            }
        }
    }
    
    private func setUpTrackingAuthorization() {
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
}


