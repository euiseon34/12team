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
  private let endHour = 24

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Button(action: { selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)! }) {
          Image(systemName: "chevron.left")
            .foregroundStyle(.white)
        }
        Spacer()
        Text(dateFormatter.string(from: selectedDate))
          .font(.headline)
          .foregroundStyle(.white)
        Spacer()
        Button(action: { selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)! }) {
          Image(systemName: "chevron.right")
            .foregroundStyle(.white)
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
                  .foregroundStyle(.white)
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
              Text("\(entry.startTime) ~ \(entry.endTime)").font(.system(size: 8))
            }
            .padding(6)
            .frame(width: UIScreen.main.bounds.width - 80, height: height)
            .background(entry.status == "유동" ? Color.purple.opacity(1.0) : Color.yellow.opacity(1.0))
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            .offset(y: startY + 10)
            .offset(x: 69)
          }
        }
        .padding(.leading)
      }
      .padding(.bottom, 100)
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
        TimetableEntry(date: Date(), startTime: "09:00", endTime: "10:30", subject: "자료구조", status: "고정"),
        TimetableEntry(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, startTime: "13:00", endTime: "15:00", subject: "운영체제", status: "고정")
      ]
    )
  }
}
