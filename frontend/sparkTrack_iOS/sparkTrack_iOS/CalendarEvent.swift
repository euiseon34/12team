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
  var completionRate: Int = 0
  
  // ✅ 추가 필요
  var category: String
  var estimatedDuration: Int = 0
  var deadline: Date? = nil
  
  var actualDuration: Int? = nil
  var canBeChecked: Bool {
    guard let start = startTime,
          let end = endTime,
          let actual = actualDuration else { return false }
    return Double(actual) >= end.timeIntervalSince(start) / 2
  }
}
