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
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        // ✅ Calendar Header
        calendarHeader
          .padding(.top)
          .padding(.horizontal)
        
        // ✅ Calendar Days
        calendarDays
          .padding(.horizontal)
          .foregroundStyle(.white)
        
        Divider()
          .padding(.horizontal)
          .padding(.top, 8)
        
        // ✅ Events List
        if let selectedDate {
          eventsList(for: selectedDate)
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
      }
      .padding(.bottom, 16)
    }
    .sheet(isPresented: $showEventForm) {
      if let selectedDate {
        EventFormView(selectedDate: .constant(selectedDate)) { title, description, category, start, end, importance, preference, estimatedDuration, deadline in
          
          // 여기서 실제 CalendarEvent 추가
          let newEvent = CalendarEvent(
            date: selectedDate,
            title: title,
            urgency: importance,
            preference: preference,
            startTime: start,
            endTime: end,
            isCompleted: false,
            category: category,
            estimatedDuration: estimatedDuration,
            deadline: deadline
          )
          
          eventStore.events.append(newEvent)
          saveEventsToUserDefaults()
        }
      }
    }
  }

  
  private var calendarHeader: some View {
    HStack {
      Button(action: { changeMonth(-1) }) {
        Image(systemName: "chevron.left")
          .foregroundColor(.white) // ✅ 화살표도 흰색
      }
      Spacer()
      Text(monthYearString(from: currentDate))
        .font(.title2)
        .foregroundColor(.white) // ✅ 월 텍스트 흰색
      Spacer()
      Button(action: { changeMonth(1) }) {
        Image(systemName: "chevron.right")
          .foregroundColor(.white) // ✅ 화살표도 흰색
      }
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
            selectedDate = koreanCalendar.startOfDay(for: date)
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
  
  private func color(for category: String) -> Color {
    switch category {
    case "공부": return Color.blue
    case "운동": return Color.green
    case "시험": return Color.red
    case "업무": return Color.orange
    case "약속": return Color.purple
    case "여행": return Color.pink
    case "기타": return Color.gray
    default: return Color.gray
    }
  }
  
  private func dayCell(for date: Date) -> some View {
    let isToday = koreanCalendar.isDateInToday(date)
    let isSelected = koreanCalendar.isDate(date, inSameDayAs: selectedDate ?? Date())
    
    let dayEvents = eventStore.events.filter { koreanCalendar.isDate($0.date, inSameDayAs: date) }
    
    return VStack(spacing: 4) {
      // 날짜 텍스트
      Text("\(koreanCalendar.component(.day, from: date))")
        .font(.system(size: 16, weight: isSelected ? .bold : .regular))
        .foregroundColor(.white) // ✅ 날짜 텍스트 흰색
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(isSelected ? Color.blue.opacity(0.5) : (isToday ? Color.yellow.opacity(0.3) : Color.clear))
        .clipShape(Circle())
      
      // 일정 카테고리 별 색상 bar 표시
      VStack(spacing: 2) {
        ForEach(Array(dayEvents.prefix(3)), id: \.id) { event in
          Rectangle()
            .fill(color(for: event.category))
            .frame(height: 3)
            .cornerRadius(1.5)
        }
        
        if dayEvents.count > 3 {
          Text("+\(dayEvents.count - 3)")
            .font(.system(size: 10))
            .foregroundColor(.gray)
        }
      }
      .frame(maxHeight: 20)
    }
    .frame(height: 80)
    .onTapGesture {
      selectedDate = koreanCalendar.startOfDay(for: date)
    }
  }
  
  private func eventsList(for date: Date) -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        Text("📅 \(formattedDate(date)) 일정")
          .font(.headline)
          .foregroundColor(.white)

        if eventsForSelectedDate.isEmpty {
          Text("등록된 일정이 없습니다.")
            .foregroundColor(.gray)
        } else {
          ForEach(eventsForSelectedDate) { event in
            HStack {
              VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                  .font(.body)
                  .fontWeight(.medium)
                  .foregroundColor(.white)

                // 만약 카테고리도 넣고 싶으면 추가 표시 가능
                Text(event.category)
                  .font(.caption)
                  .foregroundColor(.gray)
              }

              Spacer()

              Button(role: .destructive) {
                eventStore.events.removeAll { $0.id == event.id }
              } label: {
                Image(systemName: "trash")
                  .foregroundColor(.red)
              }
            }
            .padding(12)
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
          }
        }

        // 일정 추가 버튼
        Button {
          showEventForm = true
        } label: {
          Label("일정 추가", systemImage: "plus.circle")
            .font(.body)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.7))
            .cornerRadius(10)
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
