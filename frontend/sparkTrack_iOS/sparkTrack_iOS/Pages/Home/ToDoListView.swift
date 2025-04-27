//
//  ToDoListView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/27/25.
//

import SwiftUI

struct ToDoListView: View {
  @ObservedObject var eventStore: EventStore
  @State private var completedEventIDs: Set<UUID> = []
  
  private var sortedEvents: [CalendarEvent] {
    eventStore.events.sorted {
      ($0.startTime ?? $0.date) < ($1.startTime ?? $1.date)
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("📝 To-Do List")
        .font(.title3)
        .bold()
        .padding(.leading)
      
      if sortedEvents.isEmpty {
        Text("할 일이 없습니다.")
          .foregroundColor(.gray)
          .padding()
      } else {
        ForEach(sortedEvents) { event in
          VStack(alignment: .leading, spacing: 6) {
            HStack {
              
              Button(action: {
                toggleCompletion(for: event)
              }) {
                Image(systemName: completedEventIDs.contains(event.id) ? "checkmark.circle.fill" : "circle")
                  .foregroundColor(completedEventIDs.contains(event.id) ? .green : .gray)
              }
              
              Text(event.title)
                .font(.body)
                .fontWeight(.semibold)
              
              Spacer()
              
              HStack(spacing: 8) {
                Button(action: {
                  delete(event: event)
                }) {
                  Image(systemName: "trash")
                    .foregroundColor(.red)
                }
              }
            }
            
            if let start = event.startTime, let end = event.endTime {
              Text("\(formatTime(start)) - \(formatTime(end))")
                .font(.caption)
                .foregroundColor(.gray)
            }
          }
          .padding()
          .background(Color(.secondarySystemBackground))
          .cornerRadius(10)
          .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
          .padding(.horizontal)
        }
      }
    }
    .padding(.top, 20)
  }
  
  private func toggleCompletion(for event: CalendarEvent) {
    if completedEventIDs.contains(event.id) {
      completedEventIDs.remove(event.id)
    } else {
      completedEventIDs.insert(event.id)
    }
  }
  
  private func delete(event: CalendarEvent) {
    eventStore.events.removeAll { $0.id == event.id }
  }
  
  private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
}

#Preview {
  ToDoListView(eventStore: EventStore())
}
