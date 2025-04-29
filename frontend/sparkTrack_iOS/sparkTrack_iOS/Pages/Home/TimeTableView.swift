//
//  TimeTableView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/29/25.
//

import SwiftUI

struct TimeTableView: View {
  let events: [CalendarEvent]
  
  private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
  private let startHour = 9
  private let endHour = 21
  private let rowHeight: CGFloat = 40

  var body: some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(.fixed(30))] + Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {

        // 요일 헤더
        Text("") // 좌측 시간 라벨
        ForEach(daysOfWeek, id: \.self) { day in
          Text(day)
            .font(.caption)
            .bold()
            .frame(height: 30)
            .frame(maxWidth: .infinity)
        }

        // 시간표 격자
        ForEach(startHour...endHour, id: \.self) { hour in
          Text("\(hour):00")
            .font(.caption2)
            .frame(height: rowHeight)

          ForEach(1...7, id: \.self) { weekday in
            ZStack {
              Color.white
              ForEach(eventsFor(weekday: weekday, hour: hour)) { event in
                eventBlock(for: event)
              }
            }
            .frame(height: rowHeight)
            .border(Color.gray.opacity(0.3), width: 0.5)
          }
        }
      }
      .padding(.horizontal)
    }
  }

  // MARK: - Helper

  private func eventsFor(weekday: Int, hour: Int) -> [CalendarEvent] {
    events.filter { event in
      guard let start = event.startTime, let end = event.endTime else { return false }

      let eventWeekday = (Calendar.current.component(.weekday, from: event.date) + 5) % 7 + 1
      guard eventWeekday == weekday else { return false }

      let startHour = Calendar.current.component(.hour, from: start)
      let endHour = Calendar.current.component(.hour, from: end)

      return startHour <= hour && hour < endHour
    }
  }

  private func eventBlock(for event: CalendarEvent) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(event.title)
        .font(.caption)
        .bold()
        .lineLimit(1)

      if let start = event.startTime, let end = event.endTime {
        Text("\(formatTime(start)) - \(formatTime(end))")
          .font(.caption2)
          .foregroundColor(.gray)
      }
    }
    .padding(6)
    .background(randomColor(for: event))
    .cornerRadius(8)
    .frame(height: rowHeight)
  }

  private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }

  private func randomColor(for event: CalendarEvent) -> Color {
    let hash = abs(event.title.hashValue)
    let hue = Double(hash % 256) / 256.0
    return Color(hue: hue, saturation: 0.3, brightness: 0.9)
  }
}

#Preview {
  let sampleEvents = [
    CalendarEvent(
      date: Date(), // 오늘 날짜 기준
      title: "로보틱스",
      urgency: 3,
      preference: 2,
      startTime: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date()),
      endTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())
    ),
    CalendarEvent(
      date: Date(),
      title: "인공지능",
      urgency: 4,
      preference: 4,
      startTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date()),
      endTime: Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())
    )
  ]
  
  return TimeTableView(events: sampleEvents)
}
