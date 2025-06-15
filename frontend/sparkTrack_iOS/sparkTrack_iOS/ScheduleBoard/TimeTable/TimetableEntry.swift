//
//  TimeTableEntries.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/30/25.
//

import Foundation

struct TimetableEntry: Identifiable, Codable {
  let id = UUID()
  let date: Date
  let startTime: String
  let endTime: String
  let subject: String
  let status: String
}
