//
//  ToDoListView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/27/25.
//

import SwiftUI

struct ToDoListView: View {
  let constellationVM: ConstellationViewModel
  @State private var events: [CalendarEvent] = []
  
  // ✅ 초기화 시 UserDefaults에서 이벤트 불러오기
  init(events: [CalendarEvent], constellationVM: ConstellationViewModel) {
    self.constellationVM = constellationVM
    
    if let data = UserDefaults.standard.data(forKey: "savedToDoEvents"),
       let saved = try? JSONDecoder().decode([CalendarEvent].self, from: data) {
      print("✅ [UserDefaults] 저장된 ToDo 이벤트 불러오기 성공 (\(saved.count)개)")
      _events = State(initialValue: saved)
    } else {
      print("⚠️ [UserDefaults] 저장된 데이터 없음 - 초기 events 사용")
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
          }, constellationVM: constellationVM)
        }
      }
    }
    .padding(.top, 20)
    .onChange(of: events) { _ in
      saveEvents() // ✅ 이벤트 배열 변경 시 자동 저장
    }
  }
  
  // ✅ 이벤트 삭제
  private func delete(event: CalendarEvent) {
    print("🗑️ [ToDo] 이벤트 삭제: \(event.title)")
    events.removeAll { $0.id == event.id }
  }
  
  // ✅ UserDefaults에 이벤트 저장
  private func saveEvents() {
    if let data = try? JSONEncoder().encode(events) {
      UserDefaults.standard.set(data, forKey: "savedToDoEvents")
      print("💾 [UserDefaults] ToDo 이벤트 저장 완료 (\(events.count)개)")
    } else {
      print("❌ [UserDefaults] ToDo 이벤트 저장 실패 - 인코딩 오류")
    }
  }
}

struct ToDoRowView: View {
  @Binding var event: CalendarEvent
  var onDelete: () -> Void
  let constellationVM: ConstellationViewModel

  @State private var showSlider = false
  @State private var tempRate: Double = 100
  @State private var showTimer = false
  @State private var showAlert = false

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Button(action: {
          if event.isCompleted {
            event.isCompleted = false
            event.completionRate = 0
            showSlider = false
          } else if event.canBeChecked {
            event.isCompleted = true
            showSlider = true
            tempRate = Double(event.completionRate)
          } else {
            showAlert = true
          }
        }) {
          Image(systemName: event.isCompleted ? "checkmark.circle.fill" : "circle")
            .foregroundColor(event.isCompleted ? .green : (event.canBeChecked ? .blue : .gray))
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

      if showSlider {
        VStack(alignment: .leading, spacing: 8) {
          Text("이 작업의 달성도를 입력해주세요")
            .font(.caption)

          Slider(value: $tempRate, in: 0...100, step: 1)

          Text("현재 달성도: \(Int(tempRate))%")
            .font(.caption2)
            .foregroundColor(.gray)

          HStack {
            Spacer()
            Button("확인") {
              event.completionRate = Int(tempRate)
              showSlider = false

              if event.isCompleted {
                let urgency = event.urgency
                let completionRate = event.completionRate
                let score = Int(Double(urgency) * Double(completionRate) / 100.0 * 20)
                constellationVM.addScore(score)

                print("🌟 [Score] 점수 추가됨: urgency=\(urgency), rate=\(completionRate)% → +\(score)점")
              }
            }
            .font(.caption)
          }
        }
        .padding(.horizontal)
        .transition(.opacity)
      }

      if !event.isCompleted {
        Button("⏱️ 시작") {
          showTimer = true
        }
        .font(.caption)
        .sheet(isPresented: $showTimer) {
          CountdownView(
            counter: 0,
            countTo: Int(event.durationInSeconds ?? 1800),
            onComplete: { actual in
              event.actualDuration = actual
              showTimer = false
            }
          )
        }
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(12)
    .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
    .padding(.horizontal)
    .animation(.easeInOut(duration: 0.2), value: showSlider)
    .alert("아직 완료할 수 없습니다", isPresented: $showAlert) {
      Button("확인", role: .cancel) {}
    } message: {
      Text("타이머를 절반 이상 진행해야 완료 체크가 가능합니다.")
    }
  }

  private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
  
  func calculateScore(for event: CalendarEvent) -> Int {
    let importanceWeight = 0.7
    let completionWeight = 0.3

    let importanceScore = Double(event.urgency) / 5.0 * 100.0
    let completionScore = Double(event.completionRate)

    return Int((importanceWeight * importanceScore + completionWeight * completionScore).rounded())
  }
}

extension CalendarEvent {
  var durationInSeconds: Double? {
    guard let start = startTime, let end = endTime else { return nil }
    return end.timeIntervalSince(start)
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
  ], constellationVM: ConstellationViewModel())
}
