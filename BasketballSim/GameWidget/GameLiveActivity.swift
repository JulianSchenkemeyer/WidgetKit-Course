//
//  GameWidgetLiveActivity.swift
//  GameWidget
//
//  Created by Julian Schenkemeyer on 20.11.22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GameLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GameAttributes.self) { context in
            // Lock screen/banner UI goes here
            LiveActivity()
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
					HStack {
						Image("warriors")
							.teamLogoModifier(frame: 40)

						Text("100")
							.font(.title)
							.fontWeight(.semibold)
					}
                }
                DynamicIslandExpandedRegion(.trailing) {
					HStack {
						Text("100")
							.font(.title)
							.fontWeight(.semibold)

						Image("bulls")
							.teamLogoModifier(frame: 40)
					}
                }
                DynamicIslandExpandedRegion(.bottom) {
					HStack {
						Image("warriors")
							.teamLogoModifier(frame: 20)

						Text("S. Curry drains a 3")
					}
                }
            } compactLeading: {
				HStack {
					Image("warriors")
						.teamLogoModifier()

					Text("100")
						.fontWeight(.semibold)
				}
            } compactTrailing: {
				HStack {
					Text("100")
						.fontWeight(.semibold)

					Image("bulls")
						.teamLogoModifier()
				}
            } minimal: {
				// Logo of the winning team
				Image("warriors")
					.teamLogoModifier()
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
