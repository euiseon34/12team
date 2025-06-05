//
//  CalendarEvent.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/27/25.
//

import Foundation

struct CalendarEvent: Identifiable, Codable, Equatable {
  var id: UUID = UUID()
  var date: Date
  var title: String
  var urgency: Int
  var preference: Int
  var startTime: Date?
  var endTime: Date?
  var isCompleted: Bool
  var completionRate: Int = 0  // 0.0 ~ 100.0
  
  var actualDuration: Int? = nil         // 사용자가 타이머로 측정한 실제 시간(초)
  var canBeChecked: Bool {               // 자동 계산되는 속성
    guard let start = startTime,
          let end = endTime,
          let actual = actualDuration else { return false }
    return Double(actual) >= end.timeIntervalSince(start) / 2
  }
}
