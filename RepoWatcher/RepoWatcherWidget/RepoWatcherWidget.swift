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
        var entries: [RepoEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = RepoEntry(date: entryDate, repo: Repository.placeholder)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
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
