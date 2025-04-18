//
//  TabBarView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

enum Tab {
  case evaluation
  case calender
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
          case .calender:
            CalendarView(eventStore: eventStore)
              .ignoresSafeArea()
          case .home:
            HomeView(eventStore: eventStore)
              .ignoresSafeArea()
          case .summary:
            SummaryView()
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

#Preview {
  TabBarView()
}
