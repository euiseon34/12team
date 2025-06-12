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

  @State private var showConstellationDex = false
  @State private var showEventForm = false

  private var filteredEvents: [CalendarEvent] {
    eventStore.events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
  }

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      ScrollView {
        VStack(spacing: 16) {
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
        .padding(.horizontal, 16)
      }

      // ⭐️ 우측 하단 버튼들 (도감 + 일정 추가)
      VStack(alignment: .trailing, spacing: 16) {
        // ⭐️ 별자리 도감 버튼
        Button(action: {
          showConstellationDex = true
        }) {
          Image(systemName: "book.fill")
            .font(.title2)
            .frame(width: 60, height: 60)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(radius: 5)
        }

        // ⭐️ 일정 추가 버튼
        Button(action: {
          showEventForm = true
        }) {
          Image(systemName: "plus")
            .font(.title2)
            .frame(width: 60, height: 60)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(radius: 5)
        }
      }
      .padding()
      .padding(.bottom, 100)
    }

    // ⭐️ 별자리 도감 sheet 연결
    .sheet(isPresented: $showConstellationDex) {
      ConstellationDexView()
    }

    // ⭐️ 일정 추가 EventFormView 연결
    .sheet(isPresented: $showEventForm) {
      EventFormView(selectedDate: $selectedDate) { title, description, category, start, end, urgency, preference, estimatedDuration, deadline in
        // ⭐️ 저장 시 CalendarEvent 생성 후 eventStore.events에 추가
        let newEvent = CalendarEvent(
          date: selectedDate,
          title: title,
          urgency: urgency,
          preference: preference,
          startTime: start,
          endTime: end,
          isCompleted: false,
          category: category,
          estimatedDuration: estimatedDuration,
          deadline: deadline
        )
        eventStore.events.append(newEvent)

        // ✅ UserDefaults에도 저장
        if let data = try? JSONEncoder().encode(eventStore.events) {
          UserDefaults.standard.set(data, forKey: "savedToDoEvents")
          print("💾 [UserDefaults] HomeView → 이벤트 저장 완료 (\(eventStore.events.count)개)")
        }
      }
    }
  }

  private var dateNavigationBar: some View {
    HStack {
      Button(action: {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
      }) {
        Image(systemName: "chevron.left")
          .foregroundStyle(Color.white)
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
          .foregroundStyle(Color.white)
      }
    }
    .padding(.horizontal)
    .padding(.top, 45)
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
