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
				let repository = try await NetworkManager.shared.getRepository(from: RepoDummyUrl.swiftNews)
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

//struct RepoWatcherWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        RepoWatcherMediumView()
//    }
//}

@main
struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RepoWatcherMediumView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
		.supportedFamilies([.systemMedium])
    }
}

//struct RepoWatcherWidget_Previews: PreviewProvider {
//    static var previews: some View {
//		RepoWatcherMediumView(entry: RepoEntry(date: Date(), repo: Repository.placeholder))
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//    }
//}
