//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Julian Schenkemeyer on 18.08.22.
//

import WidgetKit
import SwiftUI

struct CompactRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> CompactRepoEntry {
		CompactRepoEntry(date: Date(), repo: MockData.repoOne,bottomRepo: MockData.repoTwo)
    }

    func getSnapshot(in context: Context, completion: @escaping (CompactRepoEntry) -> ()) {
		let entry = CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }
	
	func getRepoAndAvatar(for urlString: String) async throws-> Repository {
		var repository = try await NetworkManager.shared.getRepository(from: urlString)
		let avatarImageData = await NetworkManager.shared.downloadImage(from: repository.owner.avatarUrl)
		repository.avatarData = avatarImageData ?? Data()
		
		return repository
		
	}

    func getTimeline(in context: Context, completion: @escaping (Timeline<CompactRepoEntry>) -> ()) {
		Task {
			var entries: [CompactRepoEntry] = []
			// Get top repository
			do {
				let repo = try await getRepoAndAvatar(for: RepoDummyUrl.swiftNews)
				
				// Get bottom repo if in large widget
				var bottomRepo: Repository?
				if context.family == .systemLarge {
					bottomRepo = try await getRepoAndAvatar(for: RepoDummyUrl.publish)
				}
				
				// Create new entry for timeline
				let newEntry = CompactRepoEntry(date: .now, repo: repo, bottomRepo: bottomRepo)
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

struct CompactRepoEntry: TimelineEntry {
    let date: Date
	let repo: Repository
	let bottomRepo: Repository?
}

struct CompactRepoEntryView : View {
	@Environment(\.widgetFamily) var family
    var entry: CompactRepoProvider.Entry

    var body: some View {
		switch family {
		case .systemMedium:
			RepoWatcherMediumView(repository: entry.repo)
		case .systemLarge:
			RepoWatcherLargeView(repo: entry.repo, bottomRepo: entry.bottomRepo)
		case .systemExtraLarge, .systemSmall:
			EmptyView()
		@unknown default:
			EmptyView()
		}
    }
}

struct CompactRepoWidget: Widget {
    let kind: String = "CompactRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CompactRepoProvider()) { entry in
			CompactRepoEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
		.supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct CompactRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
		CompactRepoEntryView(entry: CompactRepoEntry(date: .now, repo: MockData.repoOne, bottomRepo: MockData.repoTwo))
			.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
