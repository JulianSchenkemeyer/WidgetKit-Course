//
//  BasketballSimApp.swift
//  BasketballSim
//
//  Created by Sean Allen on 11/6/22.
//

import SwiftUI

@main
struct BasketballSimApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(model: GameModel())
        }
    }
}
