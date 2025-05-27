//
//  EventStoreView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/18/25.
//

import Foundation

class EventStore: ObservableObject {
    @Published var events: [CalendarEvent] = []
}
