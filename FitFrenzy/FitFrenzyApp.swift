//
//  FitFrenzyApp.swift
//  FitFrenzy
//
//  Created by Marc Panaligan on 7/29/24.
//

import SwiftUI

@main
struct FitFrenzyApp: App {
    @StateObject var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            FitFrenzyTabView().environmentObject(manager)
        }
    }
}
