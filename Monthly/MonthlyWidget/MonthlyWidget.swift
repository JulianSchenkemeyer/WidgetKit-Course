//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Julian Schenkemeyer on 17.08.22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
	func placeholder(in context: Context) -> DayEntry {
		DayEntry(date: Date())
	}
	
	func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
		let entry = DayEntry(date: Date())
		completion(entry)
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		var entries: [DayEntry] = []
		
		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for dayOffset in 0 ..< 7 {
			let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
			let startOfDay = Calendar.current.startOfDay(for: entryDate)
			let entry = DayEntry(date: startOfDay)
			entries.append(entry)
		}
		
		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

struct DayEntry: TimelineEntry {
	let date: Date
}

struct MonthlyWidgetEntryView : View {
	var entry: DayEntry
	
	var body: some View {
		ZStack {
			ContainerRelativeShape()
				.fill(.gray)
			
			VStack {
				HStack(spacing: 4) {
					Text("⛄️")
						.font(.title)
					Text(entry.date.weekdayDisplayFormat)
						.font(.title3)
						.fontWeight(.bold)
						.minimumScaleFactor(0.6)
						.foregroundColor(.black.opacity(0.65))
				}
				
				Text(entry.date.dayDisplayFormat)
					.font(.system(size: 80, weight: .bold))
					.foregroundColor(.white.opacity(0.7))
			}
//			.padding(.top)
//			.padding(.vertical)
			.padding()
		}
	}
}

@main
struct MonthlyWidget: Widget {
	let kind: String = "MonthlyWidget"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			MonthlyWidgetEntryView(entry: entry)
		}
		.configurationDisplayName("Monthly Style Widget")
		.description("The theme of the widget changes based on the month")
		.supportedFamilies([.systemSmall])
	}
}

struct MonthlyWidget_Previews: PreviewProvider {
	static var previews: some View {
		MonthlyWidgetEntryView(entry: DayEntry(date: Date()))
			.previewContext(WidgetPreviewContext(family: .systemSmall))
	}
}


extension Date {
	var weekdayDisplayFormat: String {
		self.formatted(.dateTime.weekday(.wide))
	}
	
	var dayDisplayFormat: String {
		self.formatted(.dateTime.day())
	}
}
