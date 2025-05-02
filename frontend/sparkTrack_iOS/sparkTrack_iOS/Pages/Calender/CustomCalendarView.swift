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
  
  private let daySymbols = Calendar.current.shortWeekdaySymbols
  
  private var daysInMonth: [Date?] {
    guard let range = Calendar.current.range(of: .day, in: .month, for: currentDate),
          let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate)) else {
      return []
    }
    let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
    var dates: [Date?] = Array(repeating: nil, count: weekday - 1)
    for day in range {
      if let date = Calendar.current.date(bySetting: .day, value: day, of: currentDate) {
        dates.append(date)
      }
    }
    return dates
  }
  
  private var eventsForSelectedDate: [CalendarEvent] {
    guard let selectedDate else { return [] }
    return eventStore.events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
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
          eventStore.events.append(CalendarEvent(
            date: selectedDate,
            title: title,
            urgency: urgency,
            preference: preference,
            startTime: start,
            endTime: end
          ))
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
      ForEach(daySymbols, id: \.self) { Text($0).font(.subheadline).frame(maxWidth: .infinity) }
      ForEach(daysInMonth.indices, id: \.self) { index in
        if let date = daysInMonth[index] {
          Button(action: { selectedDate = date }) {
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
      Text("\(Calendar.current.component(.day, from: date))")
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(Calendar.current.isDate(date, inSameDayAs: selectedDate ?? Date()) ? Color.blue.opacity(0.2) : Color.clear)
        .clipShape(Circle())
      
      if eventStore.events.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
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
        Text("📅 \(date.formatted(date: .abbreviated, time: .omitted)) 일정")
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
    currentDate = Calendar.current.date(byAdding: .month, value: offset, to: currentDate) ?? currentDate
  }
  
  private func monthYearString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 M월"
    return formatter.string(from: date)
  }
}

#Preview {
  let store = EventStore()
  CustomCalendarView(eventStore: store)
}
