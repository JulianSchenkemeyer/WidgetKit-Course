//
//  RepoWatcherLargeView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Julian Schenkemeyer on 28.08.22.
//

import SwiftUI
import WidgetKit

struct RepoWatcherLargeView: View {
	let repo: Repository
	let bottomRepo: Repository?
	
	
    var body: some View {
		VStack(spacing: 35) {
			RepoWatcherMediumView(repository: repo)
			if let bottomRepo = bottomRepo {
				RepoWatcherMediumView(repository: bottomRepo)
			}
		}
    }
}

struct RepoWatcherLargeView_Previews: PreviewProvider {
    static var previews: some View {
		RepoWatcherLargeView(repo: MockData.repoTwo, bottomRepo: MockData.repoOne)
			.previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
