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
  @State private var showMatrix: Bool = false // ✅ 매트릭스 접힘 상태

  private var filteredEvents: [CalendarEvent] {
    eventStore.events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        dateNavigationBar

        // ✅ 접기/펼치기 버튼
        Button(action: {
          withAnimation {
            showMatrix.toggle()
          }
        }) {
          HStack {
            Image(systemName: showMatrix ? "chevron.down" : "chevron.right")
            Text("우선순위 매트릭스 \(showMatrix ? "접기" : "펼치기")")
          }
          .foregroundColor(.blue)
        }

        // ✅ 매트릭스 섹션 (토글됨)
        if showMatrix {
          urgencyPreferenceMatrix
        }

        todoListSection
      }
      .padding(.top, 30)
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
        .font(.title2)

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
      MatrixTask(title: $0.title, urgency: $0.urgency, preference: $0.preference)
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
