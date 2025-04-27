//
//  HomeView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct HomeView: View {
  @ObservedObject var eventStore: EventStore
  @State private var selectedDate: Date = Date()

  private var filteredEvents: [CalendarEvent] {
    eventStore.events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        dateNavigationBar
        urgencyPreferenceMatrix
        todoListSection
      }
      .padding(.top, 20)
    }
  }

  private var dateNavigationBar: some View {
    HStack {
      Button(action: {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
      }) {
        Image(systemName: "chevron.left")
      }

      Spacer()

      Text(formattedDate(selectedDate))
        .font(.headline)

      Spacer()

      Button(action: {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
      }) {
        Image(systemName: "chevron.right")
      }
    }
    .padding(.horizontal)
    .padding(.top, 50)
  }

  private var urgencyPreferenceMatrix: some View {
    UrgencyPreferenceMatrixView(tasks: filteredEvents.map {
      Task(title: $0.title, urgency: $0.urgency, preference: $0.preference)
    })
  }

  private var todoListSection: some View {
    ToDoListView(events: filteredEvents)
  }

  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 M월 d일"
    return formatter.string(from: date)
  }
}

#Preview {
  HomeView(eventStore: EventStore())
}
