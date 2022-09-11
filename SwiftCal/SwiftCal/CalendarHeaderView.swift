//
//  CalendarHeaderView.swift
//  SwiftCal
//
//  Created by Julian Schenkemeyer on 11.09.22.
//

import SwiftUI

struct CalendarHeaderView: View {
	
	let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
	var font: Font = .body
	
    var body: some View {
		HStack {
			ForEach(daysOfWeek, id: \.self) { dayOfWeek in
				Text(dayOfWeek)
					.font(font)
					.fontWeight(.black)
					.foregroundColor(.teal)
					.frame(maxWidth: .infinity)
			}
		}
    }
}

struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView()
    }
}
