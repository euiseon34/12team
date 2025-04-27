//
//  HomeView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct HomeView: View {
  @ObservedObject var eventStore: EventStore
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        UrgencyPreferenceMatrixView(tasks: eventStore.events.map {
          Task(title: $0.title, urgency: $0.urgency, preference: $0.preference)
        })
        
        ToDoListView(eventStore: eventStore)
      }
      .padding(.top, 60)
    }
  }
}

#Preview {
  HomeView(eventStore: EventStore())
}
