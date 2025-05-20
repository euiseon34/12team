//
//  sparkTrack_iOSApp.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

@main
struct sparkTrack_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            if SessionManager.shared.isLoggedIn {
                TabBarView()
            } else {
                LoginView()
            }
        }
    }
}
