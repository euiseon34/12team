//
//  ToDoEventStore.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/23/25.
//

import Foundation
import SwiftUI

class ToDoEventStore: ObservableObject {
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
    }
  }
  
  private func load() {
    if let data = UserDefaults.standard.data(forKey: "savedToDoEvents"),
       let saved = try? JSONDecoder().decode([CalendarEvent].self, from: data) {
      events = saved
    }
  }
  
  func add(_ event: CalendarEvent) {
    events.append(event)
  }
  
  func delete(_ event: CalendarEvent) {
    events.removeAll { $0.id == event.id }
  }
  
  func fetchFromServer() {
    guard let url = URL(string: "http://your-server.com/api/todos") else { return }

    URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data,
         let decoded = try? JSONDecoder().decode([CalendarEvent].self, from: data) {
        DispatchQueue.main.async {
          self.events = decoded
        }
      } else {
        print("❌ 서버에서 데이터 받아오기 실패: \(error?.localizedDescription ?? "unknown error")")
      }
    }.resume()
  }
}

