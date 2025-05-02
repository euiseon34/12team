//
//  EventFormView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/14/25.
//

import SwiftUI

struct EventFormView: View {
  @Environment(\.dismiss) private var dismiss
  
  @Binding var selectedDate: Date
  var onSave: (_ title: String, _ description: String, _ category: String, _ startTime: Date?, _ endTime: Date?, _ importance: Int, _ preference: Int) -> Void
  
  @State private var title: String = ""
  @State private var description: String = ""   // 🔹 설명 입력 필드
  @State private var selectedCategory: String = "공부"
  @State private var hasTime: Bool = false
  @State private var startTime: Date = Date()
  @State private var endTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
  @State private var importance: Int = 3
  @State private var preference: Int = 3
  @State private var repeatEvent: Bool = false
  
  let categories = ["공부", "운동", "시험", "업무", "약속", "여행", "기타"]
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("일정 이름")) {
          TextField("일정명을 입력하세요", text: $title)
        }
        
        Section(header: Text("일정 설명")) {   // 🔹 설명 입력란 추가
          TextField("간단한 설명을 입력하세요", text: $description)
        }
        
        Section(header: Text("카테고리")) {
          Picker("카테고리 선택", selection: $selectedCategory) {
            ForEach(categories, id: \.self) { Text($0) }
          }
          .pickerStyle(.menu)
        }
        
        Section(header: Text("일정 날짜")) {
          DatePicker("날짜", selection: $selectedDate, displayedComponents: .date)
          Toggle("시간 설정", isOn: $hasTime)
          if hasTime {
            DatePicker("시작 시간", selection: $startTime, displayedComponents: .hourAndMinute)
            DatePicker("종료 시간", selection: $endTime, displayedComponents: .hourAndMinute)
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
          Button("저장") {
            let formatter = ISO8601DateFormatter()
            let startString = hasTime ? formatter.string(from: startTime) : ""
            let endString = hasTime ? formatter.string(from: endTime) : ""
            
            let event = EventRequest(
              title: title,
              description: description,
              categories: "",
              urgency: importance,
              preference: preference,
              startTime: startString,
              endTime: endString,
              repeatEvent: false
            )
            
            APIService.shared.createEvent(event: event) { result in
              DispatchQueue.main.async {
                switch result {
                case .success(let response):
                  print("✅ 서버 응답: \(response)")
                case .failure(let error):
                  print("❌ 오류 발생: \(error.localizedDescription)")
                }
              }
            }
            
            onSave(title, description, selectedCategory, hasTime ? startTime : nil, hasTime ? endTime : nil, importance, preference)

            dismiss()
          }
          .disabled(title.isEmpty)
        }
        
        ToolbarItem(placement: .cancellationAction) {
          Button("취소") {
            dismiss()
          }
        }
      }
    }
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
