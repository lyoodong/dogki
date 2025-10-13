//
//  BIGIApp.swift
//  BIGI
//
//  Created by Dongwan Ryoo on 10/9/25.
//

import SwiftUI

@main
struct BIGIApp: App {
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
        }
    }
}
