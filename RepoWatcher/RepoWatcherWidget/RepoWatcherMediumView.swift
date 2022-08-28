//
//  RepoWatcherMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Julian Schenkemeyer on 21.08.22.
//

import SwiftUI
import WidgetKit

struct RepoWatcherMediumView: View {
	var repository: Repository
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				AvaterRepoNameView(avatarData: repository.avatarData, repoName: repository.name)
					.padding(.bottom, 5)
				RepoMetricsView(repo: repository)
			}
			Spacer()
			VStack {
				DaysSinceView(dateString: repository.pushedAt)
			}
		}
		.padding()
	}
}

struct AvaterRepoNameView: View {
	let avatarData: Data
	let repoName: String
	
	
	var body: some View {
		HStack {
			Image(uiImage: UIImage(data: avatarData) ?? UIImage(named: "avatar")!)
				.resizable()
				.frame(width: 50, height: 50)
				.clipShape(Circle())
				
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
		RepoWatcherMediumView(repository: Repository.placeholder)
			.previewContext(WidgetPreviewContext(family: .systemMedium))
	}
}
