//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Julian Schenkemeyer on 18.08.22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
		RepoEntry(date: Date(), repo: Repository.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
		let entry = RepoEntry(date: Date(), repo: Repository.placeholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		Task {
			var entries: [RepoEntry] = []
			do {
				var repository = try await NetworkManager.shared.getRepository(from: RepoDummyUrl.swiftNews)
				let avatarImageData = await NetworkManager.shared.downloadImage(from: repository.owner.avatarUrl)
				repository.avatarData = avatarImageData ?? Data()
				
				let newEntry = RepoEntry(date: .now, repo: repository)
				entries.append(newEntry)
			} catch {
				print("❌ Error occurred during fetching new repo data - \(error.localizedDescription)")
			}
			
			
			// Create the date for the next update in 12 hours
			let nextUpdate = Date().addingTimeInterval(43200)
			let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
			completion(timeline)
		}
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
	let repo: Repository
}

struct RepoWatcherWidgetEntryView : View {
	@Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
		switch family {
		case .systemMedium:
			RepoWatcherMediumView(repository: entry.repo)
		case .systemLarge:
			RepoWatcherLargeView()
		case .systemExtraLarge, .systemSmall:
			EmptyView()
		@unknown default:
			EmptyView()
		}
    }
}

@main
struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
			RepoWatcherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
		.supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct RepoWatcherWidget_Previews: PreviewProvider {
    static var previews: some View {
		RepoWatcherWidgetEntryView(entry: RepoEntry(date: .now, repo: Repository.placeholder))
			.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
