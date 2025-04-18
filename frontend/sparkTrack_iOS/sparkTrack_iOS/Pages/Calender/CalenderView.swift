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
        CustomCalenderView(events: $eventStore.events)
          .padding(.top, 80)
        
        Spacer()
      }
    }
}

#Preview {
  CalendarView(eventStore: EventStore())
}
