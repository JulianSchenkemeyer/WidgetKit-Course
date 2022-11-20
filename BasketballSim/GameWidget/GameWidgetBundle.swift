//
//  GameWidgetBundle.swift
//  GameWidget
//
//  Created by Julian Schenkemeyer on 20.11.22.
//

import WidgetKit
import SwiftUI

@main
struct GameWidgetBundle: WidgetBundle {
    var body: some Widget {
        GameWidget()
        GameLiveActivity()
    }
}
