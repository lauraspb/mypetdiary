//
//  mypetdiaryApp.swift
//  mypetdiary
//
//  Created by Laura Páez on 12/13/24.
//

import SwiftUI

@main
struct mypetdiaryApp: App {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    isFirstLaunch = true // Reset on every app launch
                }
        }
    }
}

#Preview {
    ContentView()
}
