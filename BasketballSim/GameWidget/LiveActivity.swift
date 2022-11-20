//
//  LiveActivity.swift
//  GameWidgetExtension
//
//  Created by Julian Schenkemeyer on 20.11.22.
//

import SwiftUI
import WidgetKit

struct LiveActivity: View {
	let context: ActivityViewContext<GameAttributes>

    var body: some View {
		ZStack {
			Image("activity-background")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.overlay {
					ContainerRelativeShape()
						.fill(.black.opacity(0.3))
				}

			VStack(spacing: 12) {
				HStack {
					Image(context.attributes.homeTeam)
						.teamLogoModifier(frame: 60)

					Text("\(context.state.gameState.homeScore)")
						.font(.system(size: 40, weight: .bold))
						.foregroundColor(.white.opacity(0.8))

					Spacer()

					Text("\(context.state.gameState.awayScore)")
						.font(.system(size: 40, weight: .bold))
						.foregroundColor(.black.opacity(0.8))

					Image(context.attributes.awayTeam)
						.teamLogoModifier(frame: 60)
				}

				HStack {
					Image(context.state.gameState.scoringTeamName)
						.teamLogoModifier(frame: 20)

					Text(context.state.gameState.lastAction)
						.font(.callout)
						.fontWeight(.semibold)
						.foregroundColor(.white.opacity(0.8))
				}
			}
			.padding()
		}
    }
}
