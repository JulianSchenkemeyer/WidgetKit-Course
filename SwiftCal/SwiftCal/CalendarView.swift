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
        animation: .default)
    private var days: FetchedResults<Day>

	let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
	
    var body: some View {
        NavigationView {
			VStack {
				HStack {
					ForEach(daysOfWeek, id: \.self) { dayOfWeek in
						Text(dayOfWeek)
							.fontWeight(.black)
							.foregroundColor(.teal)
							.frame(maxWidth: .infinity)
					}
				}
				
				LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
					
					ForEach(days) { day in
						Text(day.date!.formatted(.dateTime.day()))
							.fontWeight(.bold)
							.foregroundColor(day.didStudy ? .teal : .secondary)
							.frame(maxWidth: .infinity, minHeight: 40)
							.background(
								Circle()
									.foregroundColor(.teal.opacity(day.didStudy ? 0.3 : 0.0))
							)
					}
				}
				
				Spacer()
			}
			.padding()
			.navigationTitle(Date().formatted(.dateTime.month(.wide)))
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
