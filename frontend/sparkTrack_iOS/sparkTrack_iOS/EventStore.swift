//
//  EventStoreView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/18/25.
//

import Foundation

class EventStore: ObservableObject {
    @Published var events: [CalendarEvent] = [] {
        didSet {
            save()
        }
    }

    init() {
        load()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(data, forKey: "savedToDoEvents")
            print("💾 [UserDefaults] 이벤트 저장 완료 (\(events.count)개)")
        } else {
            print("❌ [UserDefaults] 이벤트 저장 실패")
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: "savedToDoEvents"),
           let decoded = try? JSONDecoder().decode([CalendarEvent].self, from: data) {
            self.events = decoded
            print("✅ [UserDefaults] 저장된 이벤트 불러오기 성공 (\(decoded.count)개)")
        } else {
            print("⚠️ [UserDefaults] 저장된 이벤트 없음 또는 불러오기 실패")
        }
    }

    func add(_ event: CalendarEvent) {
        events.append(event)
    }

    func delete(_ event: CalendarEvent) {
        events.removeAll { $0.id == event.id }
    }
}
