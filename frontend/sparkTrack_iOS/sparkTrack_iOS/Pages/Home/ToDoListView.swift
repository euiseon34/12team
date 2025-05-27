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

  @State private var showSlider = false
  @State private var tempRate: Double = 100

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Button(action: {
          event.isCompleted.toggle()
          if event.isCompleted {
            showSlider = true
            tempRate = Double(event.completionRate)
          } else {
            event.completionRate = 0
            showSlider = false
          }
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

          if event.isCompleted {
            Text("달성도: \(event.completionRate)%")
              .font(.caption2)
              .foregroundColor(.blue)
          }
        }

        Spacer()

        Button(role: .destructive) {
          onDelete()
        } label: {
          Image(systemName: "trash")
        }
      }

      // ✅ 달성도 슬라이더
      if showSlider {
        VStack(alignment: .leading, spacing: 8) {
          Text("이 작업의 달성도를 입력해주세요")
            .font(.caption)

          Slider(value: $tempRate, in: 0...100, step: 1)
          
          // 👇 실시간 달성도 표시
          Text("현재 달성도: \(Int(tempRate))%")
            .font(.caption2)
            .foregroundColor(.gray)

          HStack {
            Spacer()
            Button("확인") {
              event.completionRate = Int(tempRate)
              showSlider = false
            }
            .font(.caption)
          }
        }
        .padding(.horizontal)
        .transition(.opacity)
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(12)
    .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
    .padding(.horizontal)
    .animation(.easeInOut(duration: 0.2), value: showSlider)
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
