//
//  GameState.swift
//  BasketballSim
//
//  Created by Sean Allen on 11/6/22.
//

import Foundation

struct GameState: Codable, Hashable {
    let homeScore: Int
    let awayScore: Int
    let scoringTeamName: String
    let lastAction: String

    var winningTeamName: String {
        homeScore > awayScore ? "warriors" : "bulls"
    }
}
