//
//  ContentView.swift
//  SwiftCal
//
//  Created by Julian Schenkemeyer on 05.09.22.
//

import SwiftUI
import CoreData

struct CalendarView: View {
	@Environment(\.managedObjectContext) private var viewContext
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
		predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)",
							   Date().startOfCalendarWithPrefixDays as CVarArg,
							   Date().endOfMonth as CVarArg),
		animation: .default)
	private var days: FetchedResults<Day>
	
	
	var body: some View {
		NavigationView {
			VStack {
				CalendarHeaderView()
				
				LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
					
					ForEach(days) { day in
						if day.date!.monthInt != Date().monthInt {
							Text("")
						} else {
							Text(day.date!.formatted(.dateTime.day()))
								.fontWeight(.bold)
								.foregroundColor(day.didStudy ? .teal : .secondary)
								.frame(maxWidth: .infinity, minHeight: 40)
								.background(
									Circle()
										.foregroundColor(.teal.opacity(day.didStudy ? 0.3 : 0.0))
								)
								.onTapGesture {
									day.didStudy.toggle()
									do {
										try viewContext.save()
										print("✅ change didStudy to \(day.didStudy)")
									} catch {
										print("❌ changing didStudy failed")
									}
								}
						}
					}
				}
				
				Spacer()
			}
			.navigationTitle(Date().formatted(.dateTime.month(.wide)))
			.padding()
			.onAppear {
				if days.isEmpty {
					// If days is empty, we are either in a first launch scenario
					// or at the beginning of a new month, eitherway in this case
					// we want to create the new day objects for this month as
					// well as the previous month
					createMonthDays(for: .now.startOfPreviousMonth)
					createMonthDays(for: .now)
				} else if days.count < Date().numberOfDaysInMonth {
					// If we receive less than the expected number of day object from the FetchRequest,
					// it is save to say that a new month just started and we need to generate
					// new day objects.
					createMonthDays(for: .now)
				}
			}
		}
	}
	
	
	func createMonthDays(for date: Date) {
		// Create a new day object for each day in the current month
		for dayOffset in 0..<date.numberOfDaysInMonth {
			// Create new Day Core Data object and set its values
			let newDay = Day(context: viewContext)
			newDay.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: date.startOfMonth)
			newDay.didStudy = false
			
		}
		
		do {
			try viewContext.save()
			print("✅ saving of viewContext succeded for month \(date.monthFullName)")
		} catch {
			print("❌ saving of viewContext failed")
		}
	}
}

private let itemFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .short
	formatter.timeStyle = .medium
	return formatter
}()

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		CalendarView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
