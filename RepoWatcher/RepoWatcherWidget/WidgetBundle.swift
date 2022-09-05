//
//  WidgetBundle.swift
//  RepoWatcherWidgetExtension
//
//  Created by Julian Schenkemeyer on 03.09.22.
//

import SwiftUI
import WidgetKit


@main
struct RepoWatcherWidgets: WidgetBundle {
	var body: some Widget {
		CompactRepoWidget()
		ContributorWidget()
	}
}
