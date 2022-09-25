//
//  SwiftCalApp.swift
//  SwiftCal
//
//  Created by Julian Schenkemeyer on 05.09.22.
//

import SwiftUI

@main
struct SwiftCalApp: App {
    let persistenceController = PersistenceController.shared
	
	@State private var tabSelection = 0

    var body: some Scene {
        WindowGroup {
			TabView(selection: $tabSelection) {
				CalendarView()
					.tabItem {
						Label("Calendar", systemImage: "calendar")
					}
					.tag(0)
				StreakView()
					.tabItem {
						Label("Streak", systemImage: "swift")
					}
					.tag(1)
			}
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
			.onOpenURL { url in
				print(url)
			}
        }
    }
}
