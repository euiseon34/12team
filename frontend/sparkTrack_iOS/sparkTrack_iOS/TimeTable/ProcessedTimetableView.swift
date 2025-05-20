//
//  ProcessedTimetableView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/20/25.
//

import SwiftUI

struct TimetableResponse: Codable {
    let data: [TimetableEntry]
}

struct TimetableEntry: Codable, Identifiable {
  let id = UUID()
  let day: String           // "월", "화", ...
  let startTime: String     // "09:00"
  let endTime: String       // "12:00"
  let subject: String
}

struct ProcessedTimetableView: View {
  let entries: [TimetableEntry]
  
  // 요일 순서 고정
  private let weekdays = ["월", "화", "수", "목", "금"]
  
  var groupedByDay: [String: [TimetableEntry]] {
    Dictionary(grouping: entries, by: { $0.day })
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
}

#Preview {
  ProcessedTimetableView(entries: [
    TimetableEntry(day: "수", startTime: "09:00", endTime: "12:00", subject: "공업수학1"),
    TimetableEntry(day: "수", startTime: "12:00", endTime: "13:30", subject: "통계학개론"),
    TimetableEntry(day: "목", startTime: "12:00", endTime: "15:00", subject: "공학설계기")
  ])
}
