//
//  RepoWatcherLargeView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Julian Schenkemeyer on 28.08.22.
//

import SwiftUI
import WidgetKit

struct RepoWatcherLargeView: View {
    var body: some View {
		VStack(spacing: 35) {
			RepoWatcherMediumView(repository: Repository.placeholder)
			RepoWatcherMediumView(repository: Repository.placeholder)
		}
    }
}

struct RepoWatcherLargeView_Previews: PreviewProvider {
    static var previews: some View {
        RepoWatcherLargeView()
			.previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
