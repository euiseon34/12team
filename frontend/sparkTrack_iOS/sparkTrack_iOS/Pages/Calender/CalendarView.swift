//
//  CalenderView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct CalendarView: View {
  @ObservedObject var eventStore: EventStore
  
    var body: some View {
      VStack() {
        CustomCalendarView(eventStore: eventStore)
          .padding(.top, 60)
        
        Spacer()
      }
      .padding(.bottom, 100)
    }
}

#Preview {
  CalendarView(eventStore: EventStore())
}
