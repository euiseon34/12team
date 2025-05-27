//
//  TabBarView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

enum Tab {
  case evaluation
  case calendar
  case home
  case summary
  case user
}

struct TabBarView: View {
  @State var selectedTab: Tab = .home
  @StateObject var eventStore = EventStore()
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .bottom) {
        VStack(spacing: 0) {
          switch selectedTab {
          case .evaluation:
            DayEvaluationView()
              .ignoresSafeArea()
          case .calendar:
            CalendarView(eventStore: eventStore)
              .ignoresSafeArea()
          case .home:
            HomeView(eventStore: eventStore)
              .ignoresSafeArea()
          case .summary:
            SummaryView(
                allEvents: loadToDoEvents()
              )
              .padding(.top, 50)
              .ignoresSafeArea()
          case .user:
            UserPageView()
              .ignoresSafeArea()
          }
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        
        CustomTabView(selectedTab: $selectedTab)
          .frame(maxWidth: .infinity)
      }
    }
    .edgesIgnoringSafeArea(.bottom)
  }
}

func loadToDoEvents() -> [CalendarEvent] {
  if let data = UserDefaults.standard.data(forKey: "savedToDoEvents"),
     let events = try? JSONDecoder().decode([CalendarEvent].self, from: data) {
    return events
  }
  return []
}


#Preview {
  TabBarView()
}
