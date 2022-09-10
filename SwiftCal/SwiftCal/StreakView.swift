//
//  StreakView.swift
//  SwiftCal
//
//  Created by Julian Schenkemeyer on 10.09.22.
//

import SwiftUI
import CoreData

struct StreakView: View {
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
		predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)",
							   Date().startOfMonth as CVarArg,
							   Date().endOfMonth as CVarArg),
		animation: .default)
	private var days: FetchedResults<Day>
	
	
	@State private var streakValue = 0
	
    var body: some View {
		VStack {
			Text("\(streakValue)")
				.font(.system(size: 160, weight: .heavy, design: .rounded))
				.foregroundColor(streakValue > 0 ? .teal : .pink)
			
			Text("Current Streak")
				.font(.largeTitle)
				.fontWeight(.heavy)
				.foregroundColor(streakValue > 0 ? .teal : .pink)
		}
		.onAppear {
			streakValue = calculateStreakValue()
		}
    }
	
	func calculateStreakValue() -> Int {
		
		guard !days.isEmpty else { return 0 }
		
		let nonFutureDays = days.filter { $0.date!.dayInt <= Date().dayInt }
		
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

struct StreakView_Previews: PreviewProvider {
    static var previews: some View {
        StreakView()
    }
}
