//
//  ContributorWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Julian Schenkemeyer on 03.09.22.
//

import SwiftUI
import WidgetKit


struct ContributorProvider: TimelineProvider {
	func placeholder(in context: Context) -> ContributorEntry {
		ContributorEntry(date: .now, repo: MockData.repoOne)
	}
	
	func getSnapshot(in context: Context, completion: @escaping (ContributorEntry) -> Void) {
		let entry = ContributorEntry(date: .now, repo: MockData.repoOne)
		completion(entry)
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<ContributorEntry>) -> Void) {
		let entries = [ContributorEntry(date: .now, repo: MockData.repoOne)]

		// Create the date for the next update in 12 hours
		let nextUpdate = Date().addingTimeInterval(43200)
		let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
		completion(timeline)
	}
}


struct ContributorEntry: TimelineEntry {
	var date: Date
	let repo: Repository
	
}


struct ContributorEntryView: View {
	@Environment(\.widgetFamily) var family
	var entry: ContributorProvider.Entry
	
	
	var body: some View {
		
		RepoWatcherMediumView(repository: entry.repo)
		
//		switch family {
//		case .systemLarge:
//			Text("large")
//		case .systemExtraLarge, .systemSmall, .systemMedium:
//			EmptyView()
//		@unknown default:
//			EmptyView()
//		}
	}
}

struct ContributorWidget: Widget {
	let kind: String = "ContributorWidget"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: CompactRepoProvider()) { entry in
			CompactRepoEntryView(entry: entry)
		}
		.configurationDisplayName("Contributor Widget")
		.description("This is an example widget.")
		.supportedFamilies([.systemLarge])
	}
}

struct ContributorWidget_Previews: PreviewProvider {
	static var previews: some View {
		ContributorEntryView(entry: ContributorEntry(date: .now, repo: MockData.repoOne))
			.previewContext(WidgetPreviewContext(family: .systemLarge))
	}
}
