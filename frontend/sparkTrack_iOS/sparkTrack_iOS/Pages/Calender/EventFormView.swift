//
//  EvnetFormView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct EventFormView: View {
  @Environment(\.dismiss) private var dismiss

  @Binding var selectedDate: Date
  var onSave: (_ title: String, _ description: String, _ category: String, _ startTime: Date?, _ endTime: Date?, _ importance: Int, _ preference: Int) -> Void

  @State private var title: String = ""
  @State private var description: String = ""
  @State private var selectedCategory: String = "공부"
  @State private var hasTime: Bool = false
  @State private var startDate: Date = Date()
  @State private var startTime: Date = Date()
  @State private var endDate: Date = Date()
  @State private var endTime: Date = Date()
  @State private var importance: Int = 3
  @State private var preference: Int = 3
  @State private var repeatEvent: Bool = false
  @State private var showAlert = false
  @State private var alertMessage = ""

  let categories = ["공부", "운동", "시험", "업무", "약속", "여행", "기타"]

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("일정 이름")) {
          TextField("일정명을 입력하세요", text: $title)
        }

        Section(header: Text("일정 설명")) {
          TextField("간단한 설명을 입력하세요", text: $description)
        }

        Section(header: Text("카테고리")) {
          Picker("카테고리 선택", selection: $selectedCategory) {
            ForEach(categories, id: \.self) { Text($0) }
          }
          .pickerStyle(.menu)
        }

        Section(header: Text("일정 날짜 및 시간")) {
          DatePicker("시작 날짜", selection: $startDate, displayedComponents: .date)
          Toggle("시간 설정", isOn: $hasTime)
          if hasTime {
            DatePicker("시작 시각", selection: $startTime, displayedComponents: .hourAndMinute)
            DatePicker("종료 날짜", selection: $endDate, displayedComponents: .date)
            DatePicker("종료 시각", selection: $endTime, displayedComponents: .hourAndMinute)
          }
        }

        Section(header: Text("중요도")) {
          StarRatingView(rating: $importance)
        }

        Section(header: Text("선호도")) {
          StarRatingView(rating: $preference)
        }

        Section(header: Text("반복 일정 설정")) {
          Toggle("반복", isOn: $repeatEvent)
        }
      }
      .navigationTitle("일정 추가")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("저장", action: saveEvent)
        }
        ToolbarItem(placement: .cancellationAction) {
          Button("취소") {
            dismiss()
          }
        }
      }
      .alert("오류", isPresented: $showAlert) {
        Button("확인", role: .cancel) {}
      } message: {
        Text(alertMessage)
      }
      .onAppear {
        startDate = selectedDate
        endDate = selectedDate
      }
    }
  }

  private func saveEvent() {
    let calendar = Calendar.current

    var realStart: Date? = nil
    var realEnd: Date? = nil

    if hasTime {
      realStart = combine(date: startDate, time: startTime)
      realEnd = combine(date: endDate, time: endTime)

      if let s = realStart, let e = realEnd, s >= e {
        alertMessage = "종료 시각은 시작 시각보다 늦어야 합니다."
        showAlert = true
        return
      }
    }

    let formatter = ISO8601DateFormatter()
    formatter.timeZone = TimeZone.current

    let startString = realStart != nil ? formatter.string(from: realStart!) : ""
    let endString = realEnd != nil ? formatter.string(from: realEnd!) : ""

    let event = EventRequest(
      title: title,
      description: description,
      category: selectedCategory,
      repeatEvent: repeatEvent,
      completed: false,
      priority: importance,
      preference: preference,
      startTime: startString,
      endTime: endString
    )

    APIService.shared.createTask(task: event) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let response):
          print("✅ 서버 응답: \(response)")
        case .failure(let error):
          print("❌ 오류 발생: \(error.localizedDescription)")
        }
      }
    }

    onSave(title, description, selectedCategory, realStart, realEnd, importance, preference)
    dismiss()
  }

  private func combine(date: Date, time: Date) -> Date {
    let cal = Calendar.current
    let dateComp = cal.dateComponents([.year, .month, .day], from: date)
    let timeComp = cal.dateComponents([.hour, .minute, .second], from: time)
    var combined = DateComponents()
    combined.year = dateComp.year
    combined.month = dateComp.month
    combined.day = dateComp.day
    combined.hour = timeComp.hour
    combined.minute = timeComp.minute
    combined.second = timeComp.second
    return cal.date(from: combined)!
  }
}

#Preview {
  EventFormView(
    selectedDate: .constant(Date()),
    onSave: { title, description, category, start, end, imp, pref in
      print("저장된 일정: \(title), 설명: \(description)")
    }
  )
}
