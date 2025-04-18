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
  var onSave: (_ title: String, _ category: String, _ startTime: Date?, _ endTime: Date?, _ importance: Int, _ preference: Int) -> Void
  
  @State private var title: String = ""
  @State private var selectedCategory: String = "공부"
  @State private var hasTime: Bool = false
  @State private var startTime: Date = Date()
  @State private var endTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
  @State private var importance: Int = 3
  @State private var preference: Int = 3
  
  let categories = ["공부", "운동", "시험", "업무", "약속", "여행", "기타"]
  
  var body: some View {
    NavigationView {
      Form {
        // 일정 이름
        Section(header: Text("일정 이름")) {
          TextField("일정명을 입력하세요", text: $title)
        }
        
        // 카테고리
        Section(header: Text("카테고리")) {
          Picker("카테고리 선택", selection: $selectedCategory) {
            ForEach(categories, id: \.self) { Text($0) }
          }
          .pickerStyle(.menu)
        }
        
        // 날짜 + 시간
        Section(header: Text("일정 날짜")) {
          DatePicker("날짜", selection: $selectedDate, displayedComponents: .date)
          
          Toggle("시간 설정", isOn: $hasTime)
          
          if hasTime {
            DatePicker("시작 시간", selection: $startTime, displayedComponents: .hourAndMinute)
            DatePicker("종료 시간", selection: $endTime, displayedComponents: .hourAndMinute)
          }
        }
        
        // 중요도
        Section(header: Text("중요도")) {
          StarRatingView(rating: $importance)
        }
        
        // 선호도
        Section(header: Text("선호도")) {
          StarRatingView(rating: $preference)
        }
      }
      
      .navigationTitle("일정 추가")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("저장") {
            let start = hasTime ? startTime : nil
            let end = hasTime ? endTime : nil
            onSave(title, selectedCategory, start, end, importance, preference)
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
     onSave: { _,_,_,_,_,_ in }
   )
}
