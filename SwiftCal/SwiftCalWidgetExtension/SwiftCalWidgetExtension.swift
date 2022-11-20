//
//  SwiftCalWidgetExtension.swift
//  SwiftCalWidgetExtension
//
//  Created by Julian Schenkemeyer on 10.09.22.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
	
	let viewContext = PersistenceController.shared.container.viewContext
	var dayFetchRequest: NSFetchRequest<Day> {
		let request = Day.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \Day.date, ascending: true)]
		request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)",
										Date().startOfCalendarWithPrefixDays as CVarArg,
										Date().endOfMonth as CVarArg)
		
		return request
	}
	
	func placeholder(in context: Context) -> CalendarEntry {
		CalendarEntry(date: Date(), days: [])
	}
	
	func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
		do {
			let days = try viewContext.fetch(dayFetchRequest)
			
			let entry = CalendarEntry(date: Date(), days: days)
			completion(entry)
		} catch {
			print("❌ fetching days for snapshot failed")
		}
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		do {
			let days = try viewContext.fetch(dayFetchRequest)
			
			let entry = CalendarEntry(date: Date(), days: days)
			
			let timeline = Timeline(entries: [entry], policy: .after(.now.endOfDay))
			completion(timeline)
		} catch {
			print("❌ fetching days for timeline failed")
		}
	}
}

struct CalendarEntry: TimelineEntry {
	let date: Date
	let days: [Day]
}

struct SwiftCalWidgetExtensionEntryView : View {
	@Environment(\.widgetFamily) var family

	var entry: Provider.Entry
	
	var body: some View {

		switch family {
		case .systemMedium:
			MediumCalendarView(entry: entry, streakValue: calculateStreakValue())
		case .accessoryCircular:
			LockScreenCircularView(entry: entry, currentStreak: calculateStreakValue())
		case .accessoryInline:
			Label("Streak - \(calculateStreakValue()) days", systemImage: "swift")
		case .systemSmall, .systemLarge, .systemExtraLarge, .accessoryRectangular:
			EmptyView()
		@unknown default:
			EmptyView()
		}
	}
	
	func calculateStreakValue() -> Int {
		
		guard !entry.days.isEmpty else { return 0 }
		
		let nonFutureDays = entry.days.filter { $0.date!.dayInt <= Date().dayInt }
		
		var streakCount = 0
		for day in nonFutureDays.reversed() {
			if day.didStudy {
				streakCount += 1
			} else {
				if day.date!.dayInt != Date().dayInt {
					break
				}
			}
		}
		
		return streakCount
	}
}

@main
struct SwiftCalWidgetExtension: Widget {
	let kind: String = "SwiftCalWidget"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			SwiftCalWidgetExtensionEntryView(entry: entry)
		}
		.configurationDisplayName("Swift Study Calendar")
		.description("Track days you study Swift")
		.supportedFamilies([.systemMedium,
							.accessoryRectangular,
							.accessoryCircular,
							.accessoryInline])
	}
}

struct SwiftCalWidgetExtension_Previews: PreviewProvider {
	static var previews: some View {
		SwiftCalWidgetExtensionEntryView(entry: CalendarEntry(date: Date(), days: []))
			.previewContext(WidgetPreviewContext(family: .accessoryCircular))
	}
}

//MARK: UI Code for the different Widgets

private struct MediumCalendarView: View {
	let columns = Array(repeating: GridItem(.flexible()), count: 7)

	var entry: CalendarEntry
	var streakValue: Int

	var body: some View {
		HStack {
			Link(destination: URL(string: "streaks")!) {
				VStack {
					Text("\(streakValue)")
						.font(.system(size: 70, weight: .bold, design: .rounded))
						.foregroundColor(.teal)
					Text("Day Streak")
						.font(.caption)
						.foregroundColor(.secondary)
				}
			}

			Link(destination: URL(string: "calendar")!) {
				VStack {
					CalendarHeaderView(font: .caption)

					LazyVGrid(columns: columns, spacing: 7) {
						ForEach(entry.days) { day in
							if day.date!.monthInt != Date().monthInt {
								Text("")
							} else {
								Text(day.date!.formatted(.dateTime.day()))
									.font(.caption2)
									.bold()
									.frame(maxWidth: .infinity)
									.foregroundColor(day.didStudy ? .teal : .secondary)
									.background(
										Circle()
											.foregroundColor(.teal.opacity(day.didStudy ? 0.3 : 0.0))
											.scaleEffect(1.4)
									)
							}
						}
					}
				}
				.padding(.leading, 6)
			}
		}
		.padding()
	}
}

private struct LockScreenCircularView: View {
	var entry: CalendarEntry
	var currentStreak: Int

	var daysInCurrentMonth: Int {
		entry.days.filter { $0.date?.monthInt == Date().monthInt }.count
	}

	var body: some View {
		Gauge(value: Double(currentStreak), in: 1...Double(entry.days.count)) {
			Image(systemName: "swift")
		} currentValueLabel: {
			Text("\(currentStreak)")
		}
		.gaugeStyle(.accessoryCircular)
	}
}
