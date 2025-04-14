//
//  CustomCalenderView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/14/25.
//

import SwiftUI

struct CalendarEvent: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
}

struct CustomCalenderView: View {
  @State private var currentDate = Date()
  @State private var selectedDate: Date? = nil
  @State private var showEventForm = false
  @State private var events: [CalendarEvent] = []
  
  private var daysInMonth: [Date] {
    guard let range = Calendar.current.range(of: .day, in: .month, for: currentDate) else { return [] }
    return range.compactMap { day in
      Calendar.current.date(bySetting: .day, value: day, of: currentDate)
    }
  }
  
  /// ✅ 선택된 날짜에 해당하는 이벤트들
  private var eventsForSelectedDate: [CalendarEvent] {
    guard let selectedDate else { return [] }
    return events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
  }
  
  var body: some View {
    VStack(spacing: 12) {
      HStack {
        Button(action: {
          currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        }) {
          Image(systemName: "chevron.left")
        }
        
        Spacer()
        
        Text(monthYearString(from: currentDate))
          .font(.title2)
        
        Spacer()
        
        Button(action: {
          currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        }) {
          Image(systemName: "chevron.right")
        }
      }
      .padding(.horizontal)
      
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
        ForEach(daysInMonth, id: \.self) { date in
          Button(action: {
            selectedDate = date
          }) {
            ZStack(alignment: .topTrailing) {
              Text("\(Calendar.current.component(.day, from: date))")
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Calendar.current.isDate(date, inSameDayAs: selectedDate ?? Date()) ? Color.blue.opacity(0.2) : Color.clear)
                .clipShape(Circle())
              
              if events.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                Circle()
                  .fill(Color.red)
                  .frame(width: 6, height: 6)
                  .offset(x: 6, y: 2)
              }
            }
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
      .padding(.horizontal)
      
      Divider()
      
      if let selectedDate {
        HStack {
          Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
            .font(.headline)
          Spacer()
          Button("일정 추가") {
            showEventForm = true
          }
        }
        .padding(.horizontal)
        
        if eventsForSelectedDate.isEmpty {
          Text("등록된 일정이 없습니다.")
            .foregroundColor(.gray)
            .padding()
        } else {
          List {
            ForEach(eventsForSelectedDate) { event in
              Text("• \(event.title)")
            }
            .onDelete(perform: deleteEvent)
          }
          .frame(height: 150)
        }
      }
    }
    .sheet(isPresented: $showEventForm) {
      if let selectedDate {
        EventFormView(date: selectedDate) { title in
          events.append(CalendarEvent(date: selectedDate, title: title))
        }
      }
    }
  }
  
  private func deleteEvent(at offsets: IndexSet) {
    let eventsForDate = eventsForSelectedDate
    for index in offsets {
      if let eventIndex = events.firstIndex(where: {
        $0.id == eventsForDate[index].id
      }) {
        events.remove(at: eventIndex)
      }
    }
  }
  
  
  func monthYearString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter.string(from: date)
  }
}

#Preview {
    CustomCalenderView()
}
