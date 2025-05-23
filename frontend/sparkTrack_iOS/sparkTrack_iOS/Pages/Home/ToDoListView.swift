//
//  ToDoListView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/27/25.
//

import SwiftUI

struct ToDoListView: View {
  @State private var events: [CalendarEvent] = []

  init(events: [CalendarEvent]) {
    if let data = UserDefaults.standard.data(forKey: "savedToDoEvents"),
       let saved = try? JSONDecoder().decode([CalendarEvent].self, from: data) {
      _events = State(initialValue: saved)
    } else {
      _events = State(initialValue: events)
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("📝 To-Do List")
        .font(.title3)
        .bold()
        .padding(.leading)

      if events.isEmpty {
        Text("할 일이 없습니다.")
          .foregroundColor(.gray)
          .padding()
      } else {
        ForEach($events) { $event in
          ToDoRowView(event: $event, onDelete: {
            delete(event: event)
          })
        }
      }
    }
    .padding(.top, 20)
    .onChange(of: events) { _ in
      saveEvents()
    }
  }

  private func delete(event: CalendarEvent) {
    events.removeAll { $0.id == event.id }
  }

  private func saveEvents() {
    if let data = try? JSONEncoder().encode(events) {
      UserDefaults.standard.set(data, forKey: "savedToDoEvents")
    }
  }
}


struct ToDoRowView: View {
  @Binding var event: CalendarEvent
  var onDelete: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Button(action: {
          event.isCompleted.toggle() // 상태 변경 바인딩
        }) {
          Image(systemName: event.isCompleted ? "checkmark.circle.fill" : "circle")
            .foregroundColor(event.isCompleted ? .green : .gray)
        }

        VStack(alignment: .leading, spacing: 4) {
          Text(event.title)
            .font(.body)
            .fontWeight(.semibold)
            .strikethrough(event.isCompleted, color: .gray)
            .foregroundColor(event.isCompleted ? .gray : .primary)

          if let start = event.startTime, let end = event.endTime {
            Text("\(formatTime(start)) - \(formatTime(end))")
              .font(.caption)
              .foregroundColor(.gray)
          }
        }

        Spacer()

        Button(role: .destructive) {
          onDelete()
        } label: {
          Image(systemName: "trash")
        }
      }
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(12)
      .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
    }
    .padding(.horizontal)
  }

  private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
}

#Preview {
  ToDoListView(events: [
    CalendarEvent(
      date: Date(),
      title: "스터디 준비",
      urgency: 4,
      preference: 5,
      startTime: Date(),
      endTime: Calendar.current.date(byAdding: .hour, value: 1, to: Date()),
      isCompleted: false
    )
  ])
}
