//
//  ProcessedTimeTableView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/30/25.
//

import SwiftUI

struct TimetableResponse: Codable {
  let data: [TimetableEntry]
}

struct ProcessedTimetableView: View {
  let entries: [TimetableEntry]

  private let weekdays = ["월", "화", "수", "목", "금", "토", "일"]

  var groupedByDay: [String: [TimetableEntry]] {
    Dictionary(grouping: entries) { entry in
      weekdayString(from: entry.date)
    }
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        ForEach(weekdays, id: \.self) { day in
          VStack(alignment: .leading, spacing: 4) {
            Text("📅 \(day)요일")
              .font(.headline)

            let dayEntries = groupedByDay[day] ?? []
            if dayEntries.isEmpty {
              Text(" - 없음")
                .font(.caption)
                .foregroundColor(.gray)
            } else {
              ForEach(dayEntries) { entry in
                HStack {
                  VStack(alignment: .leading, spacing: 2) {
                    Text(entry.subject)
                      .font(.subheadline)
                      .bold()
                    Text("\(entry.startTime) - \(entry.endTime)")
                      .font(.caption)
                      .foregroundColor(.secondary)
                  }
                  Spacer()
                }
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
              }
            }
          }
        }
      }
      .padding()
    }
  }

  private func weekdayString(from date: Date) -> String {
    let weekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"]
    let index = Calendar.current.component(.weekday, from: date) - 1
    return weekdaySymbols[(index + 7) % 7]
  }
}

#Preview {
  ProcessedTimetableView(entries: [
    TimetableEntry(date: Date(), startTime: "09:00", endTime: "12:00", subject: "공업수학1"),
    TimetableEntry(date: Date(), startTime: "13:00", endTime: "14:30", subject: "통계학개론"),
    TimetableEntry(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, startTime: "12:00", endTime: "15:00", subject: "공학설계기")
  ])
}
