//
//  StumeetApp.swift
//  Stumeet
//
//  Created by Hohyeon Moon on 2/5/24.
//

import SwiftUI

import PretendardKit

@main
struct StumeetApp: App {
    
    init() {
        PretendardKit.register()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
