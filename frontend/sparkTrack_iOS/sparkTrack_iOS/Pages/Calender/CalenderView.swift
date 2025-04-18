//
//  CalenderView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct CalendarView: View {
  @State var dummyEvents: [CalendarEvent] = [
    CalendarEvent(date: Date(), title: "예시 일정", urgency: 3, preference: 4)
  ]
  
    var body: some View {
      VStack() {
        CustomCalenderView(events: $dummyEvents)
          .padding(.top, 80)
        
        Spacer()
      }
    }
}

#Preview {
    CalendarView()
}
