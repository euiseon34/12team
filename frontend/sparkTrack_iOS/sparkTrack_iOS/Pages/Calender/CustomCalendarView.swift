//
//  CustomCalenderView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/14/25.
//

import SwiftUI

struct CustomCalendarView: View {
  @ObservedObject var eventStore: EventStore

  @State private var currentDate = Date()
  @State private var selectedDate: Date? = nil
  @State private var showEventForm = false

  private var koreanCalendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.timeZone = TimeZone.current
    calendar.firstWeekday = 2
    return calendar
  }

  private var weekdaySymbols: [String] {
    let symbols = koreanCalendar.shortWeekdaySymbols
    return Array(symbols[1...]) + [symbols[0]]
  }

  private var daysInMonth: [Date?] {
    guard let range = koreanCalendar.range(of: .day, in: .month, for: currentDate),
          let firstDayOfMonth = koreanCalendar.date(from: koreanCalendar.dateComponents([.year, .month], from: currentDate)) else {
      return []
    }

    let weekday = koreanCalendar.component(.weekday, from: firstDayOfMonth)
    let adjustedWeekday = (weekday + 5) % 7

    var dates: [Date?] = Array(repeating: nil, count: adjustedWeekday)

    for day in range {
      var components = koreanCalendar.dateComponents([.year, .month], from: currentDate)
      components.day = day
      components.hour = 0
      components.minute = 0
      components.second = 0

      if let date = koreanCalendar.date(from: components) {
        let fixed = koreanCalendar.startOfDay(for: date)
        dates.append(fixed)
      }
    }

    return dates
  }


  private var eventsForSelectedDate: [CalendarEvent] {
    guard let selectedDate else { return [] }
    return eventStore.events.filter {
      koreanCalendar.isDate($0.date, inSameDayAs: selectedDate)
    }
  }

  var body: some View {
    VStack {
      calendarHeader
      calendarDays
      Divider()
      if let selectedDate {
        eventsList(for: selectedDate)
      }
    }
    .sheet(isPresented: $showEventForm) {
      if let selectedDate {
        EventFormView(selectedDate: .constant(selectedDate)) { title, description, category, start, end, urgency, preference in
          let newEvent = CalendarEvent(
            date: selectedDate,
            title: title,
            urgency: urgency,
            preference: preference,
            startTime: start,
            endTime: end,
            isCompleted: false
          )
          eventStore.events.append(newEvent)
          saveEventsToUserDefaults() // ✅ 여기서 저장해주기!
        }
      }
    }
  }

  private var calendarHeader: some View {
    HStack {
      Button(action: { changeMonth(-1) }) { Image(systemName: "chevron.left") }
      Spacer()
      Text(monthYearString(from: currentDate))
        .font(.title2)
      Spacer()
      Button(action: { changeMonth(1) }) { Image(systemName: "chevron.right") }
    }
    .padding(.horizontal)
  }

  private var calendarDays: some View {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
      ForEach(weekdaySymbols, id: \.self) {
        Text($0)
          .font(.subheadline)
          .frame(maxWidth: .infinity)
      }

      ForEach(daysInMonth.indices, id: \.self) { index in
        if let date = daysInMonth[index] {
          Button(action: {
            selectedDate = koreanCalendar.startOfDay(for: date) // ✅ 날짜 시간 고정
          }) {
            dayCell(for: date)
          }
          .buttonStyle(PlainButtonStyle())
        } else {
          Color.clear.frame(height: 44)
        }
      }
    }
    .padding(.horizontal)
  }

  private func dayCell(for date: Date) -> some View {
    ZStack(alignment: .topTrailing) {
      Text("\(koreanCalendar.component(.day, from: date))")
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(koreanCalendar.isDate(date, inSameDayAs: selectedDate ?? Date()) ? Color.blue.opacity(0.2) : Color.clear)
        .clipShape(Circle())

      if eventStore.events.contains(where: { koreanCalendar.isDate($0.date, inSameDayAs: date) }) {
        Circle()
          .fill(Color.red)
          .frame(width: 6, height: 6)
          .offset(x: 6, y: 2)
      }
    }
  }

  private func eventsList(for date: Date) -> some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("📅 \(formattedDate(date)) 일정")
          .font(.headline)
        if eventsForSelectedDate.isEmpty {
          Text("등록된 일정이 없습니다.").foregroundColor(.gray)
        } else {
          ForEach(eventsForSelectedDate) { event in
            HStack {
              Text("• \(event.title)")
              Spacer()
              Button(role: .destructive) {
                eventStore.events.removeAll { $0.id == event.id }
              } label: {
                Image(systemName: "trash")
              }
            }
            .padding(.vertical, 2)
          }
        }
        Button {
          showEventForm = true
        } label: {
          Label("일정 추가", systemImage: "plus.circle")
        }
        .padding(.top, 8)
      }
      .padding()
    }
  }

  private func changeMonth(_ offset: Int) {
    currentDate = koreanCalendar.date(byAdding: .month, value: offset, to: currentDate) ?? currentDate
  }

  private func monthYearString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy년 M월"
    return formatter.string(from: date)
  }

  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy년 M월 d일"
    return formatter.string(from: date)
  }
  
  func saveEventsToUserDefaults() {
    if let data = try? JSONEncoder().encode(eventStore.events) {
      UserDefaults.standard.set(data, forKey: "savedToDoEvents")
    }
  }
}

#Preview {
  let store = EventStore()
  CustomCalendarView(eventStore: store)
}
