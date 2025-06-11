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

  // ⭐️ 별자리 도감 sheet 표시 여부 상태 추가
  @State private var showConstellationDex = false

  private var filteredEvents: [CalendarEvent] {
    eventStore.events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
  }

  var body: some View {
    ZStack {
      ScrollView {
        VStack(spacing: 20) {
          dateNavigationBar

          ConstellationBoardView(viewModel: constellationVM)
            .padding(.top, 20)

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
        .padding(.horizontal, 16) // ✅ 양옆 여백 추가
      }

      // ⭐️ 플로팅 버튼
      VStack {
        Spacer()
        HStack {
          Spacer()
          Button(action: {
            showConstellationDex = true
          }) {
            ZStack {
              Circle()
                .fill(Color.yellow)
                .frame(width: 60, height: 60)
                .shadow(radius: 5)

              Image(systemName: "book.fill")
                .foregroundColor(.black)
                .font(.title2)
            }
          }
          .padding()
          .padding(.bottom, 100)
        }
      }
    }
    // ⭐️ 별자리 도감 sheet 연결
    .sheet(isPresented: $showConstellationDex) {
      ConstellationDexView()
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
        .foregroundStyle(Color.white)

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
