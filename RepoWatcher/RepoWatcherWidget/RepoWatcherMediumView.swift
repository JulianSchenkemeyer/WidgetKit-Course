//
//  RepoWatcherMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Julian Schenkemeyer on 21.08.22.
//

import SwiftUI
import WidgetKit

struct RepoWatcherMediumView: View {
	var entry: RepoEntry
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				AvaterRepoNameView(avatarUrl: entry.repo.owner.avatarUrl, repoName: entry.repo.name)
					.padding(.bottom, 5)
				RepoMetricsView(repo: entry.repo)
			}
			Spacer()
			VStack {
				DaysSinceView(dateString: entry.repo.pushedAt)
			}
		}
		.padding()
	}
}

struct AvaterRepoNameView: View {
	let avatarUrl: String
	let repoName: String
	
	
	var body: some View {
		HStack {
			Circle()
				.frame(width: 50, height: 50)
			Text(repoName)
				.font(.title2)
				.fontWeight(.semibold)
				.minimumScaleFactor(0.6)
				.lineLimit(1)
		}
	}
}

struct RepoMetricsView: View {
	let repo: Repository
	
	var body: some View {
		HStack {
			RepoMetricView(symbol: "star.fill", value: repo.watchers)
			
			RepoMetricView(symbol: "tuningfork", value: repo.forks)
			
			if repo.hasIssues {
				RepoMetricView(symbol: "exclamationmark.triangle.fill", value: repo.openIssues)
			}
		}
	}
}

struct RepoMetricView: View {
	let symbol: String
	let value: Int
	
	var body: some View {
		
		Label {
			Text("\(value)")
				.font(.footnote)
				.fontWeight(.medium)
		} icon: {
			Image(systemName: symbol)
				.foregroundColor(.green)
		}
	}
}

struct DaysSinceView: View {
	let dateString: String
	let formatter = ISO8601DateFormatter()

	var daysSince: Int {
		calculateDaysSince(from: dateString)
	}
	
	func calculateDaysSince(from dateString: String) -> Int {
		let lastActivityDate = formatter.date(from: dateString) ?? .now
		
		let daysSinceLastActivity = Calendar.current.dateComponents([.day], from: lastActivityDate, to: .now).day ?? 0
		
		return daysSinceLastActivity
	}
	
	
	var body: some View {
		Text("\(daysSince)")
			.font(.system(size: 70))
			.fontWeight(.bold)
			.frame(width: 90)
			.minimumScaleFactor(0.6)
			.lineLimit(1)
			.foregroundColor(daysSince < 50 ? .green : .pink)
		Text("days ago")
			.font(.caption2)
			.foregroundColor(.secondary)
	}
}


struct RepoWatcherMediumView_Previews: PreviewProvider {
	static var previews: some View {
		RepoWatcherMediumView(entry: RepoEntry(date: Date(), repo: Repository.placeholder))
			.previewContext(WidgetPreviewContext(family: .systemMedium))
	}
}
