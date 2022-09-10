//
//  StreakView.swift
//  SwiftCal
//
//  Created by Julian Schenkemeyer on 10.09.22.
//

import SwiftUI

struct StreakView: View {
	
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
    }
}

struct StreakView_Previews: PreviewProvider {
    static var previews: some View {
        StreakView()
    }
}
