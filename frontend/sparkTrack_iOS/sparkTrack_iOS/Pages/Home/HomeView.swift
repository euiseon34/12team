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
  @State private var selectedSection: HomeSection = .todo
  @StateObject private var constellationVM = ConstellationViewModel()

  private var filteredEvents: [CalendarEvent] {
    eventStore.events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        dateNavigationBar

        ConstellationBoardView(viewModel: constellationVM)
        
        Picker("보기", selection: $selectedSection) {
          ForEach(HomeSection.allCases, id: \.self) { section in
            Text(section.rawValue).tag(section)
          }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)

        if selectedSection == .todo {
          ToDoListView(
            events: $eventStore.events,
            selectedDate: selectedDate,
            constellationVM: constellationVM
          )
        } else {
          UrgencyPreferenceMatrixView(tasks: filteredEvents.map {
            MatrixTask(title: $0.title, urgency: $0.urgency, preference: $0.preference)
          })
        }

        Spacer()
          .frame(height: 80) // ✅ 탭바에 가려지지 않도록 하단 여백 추가
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

  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 M월 d일"
    return formatter.string(from: date)
  }
}

enum HomeSection: String, CaseIterable {
  case todo = "투두"
  case matrix = "사분면"
}

#Preview {
  HomeView(eventStore: EventStore())
}

