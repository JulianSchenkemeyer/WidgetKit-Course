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
	let config: MonthConfig
	
	init(date: Date) {
		self.date = date
		self.config = MonthConfig.determineConfig(from: date)
	}
}

struct MonthlyWidgetEntryView : View {
	var entry: DayEntry
	
	var body: some View {
		ZStack {
			ContainerRelativeShape()
				.fill(entry.config.backgroundColor)
			
			VStack {
				HStack(spacing: 4) {
					Text(entry.config.emojiText)
						.font(.title)
					Text(entry.date.weekdayDisplayFormat)
						.font(.title3)
						.fontWeight(.bold)
						.minimumScaleFactor(0.6)
						.foregroundColor(entry.config.weekdayTextColor)
				}
				
				Text(entry.date.dayDisplayFormat)
					.font(.system(size: 80, weight: .bold))
					.foregroundColor(entry.config.dayTextColor)
			}
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
		MonthlyWidgetEntryView(entry: DayEntry(date: dateToDisplay(month: 13, day: 13)))
			.previewContext(WidgetPreviewContext(family: .systemSmall))
	}
	
	static func dateToDisplay(month: Int, day: Int) -> Date {
		let components = DateComponents(
			calendar: Calendar.current,
			month: month,
			day: day)
		return Calendar.current.date(from: components)!
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
