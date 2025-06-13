//
//  GridTimeTableView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/22/25.
//

import SwiftUI

struct GridTimeTableView: View {
  let entries: [TimetableEntry]

  private let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
  private let startHour = 8
  private let endHour = 24
  private let hourHeight: CGFloat = 60

  var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        HStack(spacing: 1) {
          Text("").frame(width: 40)
          ForEach(weekdays, id: \.self) { day in
            Text(day)
              .font(.caption)
              .foregroundStyle(.white)
              .frame(maxWidth: .infinity)
              .frame(height: 30)
              .background(Color.gray.opacity(0.2))
          }
        }
        
        ZStack(alignment: .topLeading) {
          VStack(spacing: 0) {
            ForEach(startHour..<endHour, id: \.self) { hour in
              HStack(spacing: 1) {
                Text(String(format: "%02d:00", hour))
                  .font(.caption2)
                  .foregroundStyle(.white)
                  .frame(width: 40, height: hourHeight, alignment: .top)
                ForEach(weekdays, id: \.self) { _ in
                  Rectangle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 0.5)
                    .frame(height: hourHeight)
                }
              }
            }
          }
          
          ForEach(entries) { entry in
            let weekday = weekdayString(from: entry.date)
            if let xIndex = weekdays.firstIndex(of: weekday) {
              let startY = yOffset(for: entry.startTime)
              let height = blockHeight(start: entry.startTime, end: entry.endTime)
              
              VStack(spacing: 2) {
                Text(entry.subject)
                  .font(.caption2)
                  .fontWeight(.semibold)
                Text("\(entry.startTime)~\(entry.endTime)")
                  .font(.caption2)
//                  .foregroundColor(.gray)
              }
              .padding(4)
              .frame(width: blockWidth, height: height)
              .background(Color.yellow.opacity(1.0))
              .cornerRadius(6)
              .position(
                x: 40 + blockWidth * CGFloat(xIndex) + blockWidth / 2,
                y: 1 + startY + height / 2
              )
            }
          }
        }
      }
    }
    .padding(.bottom, 100)
  }

  var blockWidth: CGFloat {
    (UIScreen.main.bounds.width - 40 - CGFloat(weekdays.count - 1)) / CGFloat(weekdays.count)
  }

  func yOffset(for time: String) -> CGFloat {
    let minutes = hourStringToMinutes(time)
    return CGFloat(minutes - startHour * 60) / 60 * hourHeight
  }

  func blockHeight(start: String, end: String) -> CGFloat {
    CGFloat(hourStringToMinutes(end) - hourStringToMinutes(start)) / 60 * hourHeight
  }

  func hourStringToMinutes(_ time: String) -> Int {
    let parts = time.split(separator: ":").compactMap { Int($0) }
    return parts[0] * 60 + parts[1]
  }

  func weekdayString(from date: Date) -> String {
    let weekdayIndex = Calendar.current.component(.weekday, from: date)
    let symbols = ["일", "월", "화", "수", "목", "금", "토"]
    return symbols[(weekdayIndex - 1 + 7) % 7]
  }
}

#Preview {
  GridTimeTableView(entries: [
    TimetableEntry(date: Date(), startTime: "09:00", endTime: "13:00", subject: "근로"),
    TimetableEntry(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, startTime: "10:00", endTime: "11:00", subject: "문화이론과 대중문화"),
    TimetableEntry(date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, startTime: "13:00", endTime: "14:30", subject: "캐릭터 유형론"),
    TimetableEntry(date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!, startTime: "15:00", endTime: "16:30", subject: "문학의 이해")
  ])
}
