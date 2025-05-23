//
//  GridTimeTableView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/22/25.
//

import SwiftUI

struct GridTimeTableView: View {
  let entries: [TimetableEntry]
  
  private let weekdays = ["월", "화", "수", "목", "금"]
  private let startHour = 8
  private let endHour = 20
  private let hourHeight: CGFloat = 60
  
  var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        // 요일 헤더
        HStack(spacing: 1) {
          Text("")
            .frame(width: 40)
          ForEach(weekdays, id: \.self) { day in
            Text(day)
              .font(.caption)
              .frame(maxWidth: .infinity)
              .frame(height: 30)
              .background(Color.gray.opacity(0.2))
          }
        }
        
        ZStack(alignment: .topLeading) {
          // 시간 + 줄
          VStack(spacing: 0) {
            ForEach(startHour..<endHour, id: \.self) { hour in
              HStack(spacing: 1) {
                Text(String(format: "%02d:00", hour))
                  .font(.caption2)
                  .frame(width: 40, height: hourHeight, alignment: .top)
                  .padding(.top, 2)
                
                ForEach(weekdays, id: \.self) { _ in
                  Rectangle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 0.5)
                    .frame(height: hourHeight)
                }
              }
            }
          }
          
          // 과목 블록
          ForEach(entries) { entry in
            if let xIndex = weekdays.firstIndex(of: entry.day) {
              let startY = yOffset(for: entry.startTime)
              let height = blockHeight(start: entry.startTime, end: entry.endTime)
              
              VStack(spacing: 2) {
                Text(entry.subject)
                  .font(.caption2)
                  .fontWeight(.semibold)
                  .multilineTextAlignment(.center)
                Text("\(entry.startTime)~\(entry.endTime)")
                  .font(.caption2)
                  .foregroundColor(.gray)
              }
              .padding(4)
              .frame(width: blockWidth, height: height)
              .background(colorFor(entry.subject))
              .cornerRadius(6)
              .position(
                x: 40 + blockWidth * CGFloat(xIndex) + blockWidth / 2,
                y: 5 + startY + height / 2
              )
            }
          }
        }
      }
    }
  }
  
  // MARK: - 계산
  
  var blockWidth: CGFloat {
    (UIScreen.main.bounds.width - 40 - CGFloat(weekdays.count - 1)) / CGFloat(weekdays.count)
  }
  
  func yOffset(for time: String) -> CGFloat {
    let minutes = hourStringToMinutes(time)
    let totalMinutes = (minutes - startHour * 60)
    return CGFloat(totalMinutes) / 60 * hourHeight
  }
  
  func blockHeight(start: String, end: String) -> CGFloat {
    let startM = hourStringToMinutes(start)
    let endM = hourStringToMinutes(end)
    return CGFloat(endM - startM) / 60 * hourHeight
  }
  
  func hourStringToMinutes(_ time: String) -> Int {
    let parts = time.split(separator: ":").compactMap { Int($0) }
    return parts[0] * 60 + parts[1]
  }
  
  func colorFor(_ subject: String) -> Color {
    let colors: [Color] = [.red.opacity(0.3), .blue.opacity(0.3), .green.opacity(0.3), .orange.opacity(0.3), .purple.opacity(0.3), .pink.opacity(0.3)]
    let hash = subject.hashValue
    return colors[abs(hash) % colors.count]
  }
}

#Preview {
  GridTimeTableView(entries: [
    TimetableEntry(day: "월", startTime: "09:00", endTime: "13:00", subject: "근로"),
    TimetableEntry(day: "화", startTime: "10:00", endTime: "11:00", subject: "문화이론과 대중문화"),
    TimetableEntry(day: "수", startTime: "13:00", endTime: "14:30", subject: "캐릭터 유형론"),
    TimetableEntry(day: "금", startTime: "15:00", endTime: "16:30", subject: "문학의 이해")
  ])
}
