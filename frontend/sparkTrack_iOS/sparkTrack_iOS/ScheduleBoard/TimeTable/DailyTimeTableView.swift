//
//  DailyTimeTableView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/30/25.
//

import SwiftUI

struct DailyTimeTableView: View {
  @Binding var selectedDate: Date
  let entries: [TimetableEntry]

  private let hourHeight: CGFloat = 60
  private let startHour = 8
  private let endHour = 20

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Button(action: { selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)! }) {
          Image(systemName: "chevron.left")
        }
        Spacer()
        Text(dateFormatter.string(from: selectedDate))
          .font(.headline)
        Spacer()
        Button(action: { selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)! }) {
          Image(systemName: "chevron.right")
        }
      }
      .padding()

      ScrollView {
        ZStack(alignment: .topLeading) {
          VStack(spacing: 0) {
            ForEach(startHour..<endHour, id: \.self) { hour in
              HStack {
                Text(String(format: "%02d:00", hour))
                  .font(.caption)
                  .frame(width: 60, alignment: .trailing)
                Rectangle()
                  .fill(Color.gray.opacity(0.1))
                  .frame(height: hourHeight)
              }
            }
          }

          ForEach(filteredEntries) { entry in
            let startY = yOffset(for: entry.startTime)
            let height = blockHeight(start: entry.startTime, end: entry.endTime)

            VStack(spacing: 4) {
              Text(entry.subject).font(.caption).bold()
              Text("\(entry.startTime) ~ \(entry.endTime)").font(.caption2)
            }
            .padding(6)
            .frame(width: UIScreen.main.bounds.width - 80, height: height)
            .background(Color.yellow.opacity(0.8))
            .cornerRadius(8)
            .offset(y: startY + 10)
            .offset(x: 69)
          }
        }
        .padding(.leading)
      }
    }
  }

  private var filteredEntries: [TimetableEntry] {
    entries.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
  }

  private func yOffset(for time: String) -> CGFloat {
    let parts = time.split(separator: ":").compactMap { Int($0) }
    let minutes = parts[0] * 60 + parts[1]
    return CGFloat(minutes - startHour * 60) / 60 * hourHeight
  }

  private func blockHeight(start: String, end: String) -> CGFloat {
    CGFloat(hourStringToMinutes(end) - hourStringToMinutes(start)) / 60 * hourHeight
  }

  private func hourStringToMinutes(_ time: String) -> Int {
    let parts = time.split(separator: ":").compactMap { Int($0) }
    return parts[0] * 60 + parts[1]
  }

  private var dateFormatter: DateFormatter {
    let f = DateFormatter()
    f.locale = Locale(identifier: "ko_KR")
    f.dateFormat = "M월 d일 (E)"
    return f
  }
}

#Preview {
  StatefulPreviewWrapper(Date()) { selectedDate in
    DailyTimeTableView(
      selectedDate: selectedDate,
      entries: [
        TimetableEntry(date: Date(), startTime: "09:00", endTime: "10:30", subject: "자료구조"),
        TimetableEntry(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, startTime: "13:00", endTime: "15:00", subject: "운영체제")
      ]
    )
  }
}
