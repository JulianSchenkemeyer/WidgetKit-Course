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

    var body: some Scene {
        WindowGroup {
            CalendarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
