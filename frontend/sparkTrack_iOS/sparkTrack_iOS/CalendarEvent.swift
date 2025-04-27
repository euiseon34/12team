//
//  CalendarEvent.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/27/25.
//

import Foundation

struct CalendarEvent: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let urgency: Int
    let preference: Int
    let startTime: Date?
    let endTime: Date?
}
