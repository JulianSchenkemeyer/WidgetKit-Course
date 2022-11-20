//
//  LiveActivity.swift
//  GameWidgetExtension
//
//  Created by Julian Schenkemeyer on 20.11.22.
//

import SwiftUI
import WidgetKit

struct LiveActivity: View {
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
					Image("warriors")
						.teamLogoModifier(frame: 60)

					Text("125")
						.font(.system(size: 40, weight: .bold))
						.foregroundColor(.white.opacity(0.8))

					Spacer()

					Text("125")
						.font(.system(size: 40, weight: .bold))
						.foregroundColor(.black.opacity(0.8))

					Image("warriors")
						.teamLogoModifier(frame: 60)
				}

				HStack {
					Image("warriors")
						.teamLogoModifier(frame: 20)

					Text("S. Curry drains a 3")
						.font(.callout)
						.fontWeight(.semibold)
						.foregroundColor(.white.opacity(0.8))
				}
			}
			.padding()
		}
    }
}

struct LiveActivity_Previews: PreviewProvider {
    static var previews: some View {
        LiveActivity()
			.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
