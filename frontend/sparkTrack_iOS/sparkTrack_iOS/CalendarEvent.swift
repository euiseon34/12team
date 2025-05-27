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
  var completionRate: Int = 0  // ✅ 달성도 (0~100)
}
