//
//  AIScheduleInputView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/15/25.
//

import SwiftUI

// 🔽 신규 뷰 추가: 개강/종강/시험일 입력 화면
struct AIScheduleInputView: View {
  @State private var startDate = Date()
  @State private var endDate = Date()
  @State private var midtermRange = Date()...Date()
  @State private var finalRange = Date()...Date()

  var onConfirm: (_ start: Date, _ end: Date, _ midterm: ClosedRange<Date>, _ final: ClosedRange<Date>) -> Void

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("📅 학기 정보")) {
          DatePicker("개강일", selection: $startDate, displayedComponents: .date)
          DatePicker("종강일", selection: $endDate, displayedComponents: .date)
        }

        Section(header: Text("📝 시험 기간")) {
          DatePicker("중간고사 시작", selection: Binding(get: { midtermRange.lowerBound }, set: { midtermRange = $0...midtermRange.upperBound }), displayedComponents: .date)
          DatePicker("중간고사 종료", selection: Binding(get: { midtermRange.upperBound }, set: { midtermRange = midtermRange.lowerBound...$0 }), displayedComponents: .date)

          DatePicker("기말고사 시작", selection: Binding(get: { finalRange.lowerBound }, set: { finalRange = $0...finalRange.upperBound }), displayedComponents: .date)
          DatePicker("기말고사 종료", selection: Binding(get: { finalRange.upperBound }, set: { finalRange = finalRange.lowerBound...$0 }), displayedComponents: .date)
        }
      }
      .navigationTitle("AI 일정 생성")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("생성") {
            onConfirm(startDate, endDate, midtermRange, finalRange)
          }
        }
        ToolbarItem(placement: .cancellationAction) {
          Button("취소") {
            // 닫기용 빈 콜백
            onConfirm(startDate, endDate, midtermRange, finalRange)
          }
        }
      }
    }
  }
}

#Preview {
  AIScheduleInputView { start, end, midterm, final in
    print("개강일: \(start)")
    print("종강일: \(end)")
    print("중간고사: \(midterm.lowerBound) ~ \(midterm.upperBound)")
    print("기말고사: \(final.lowerBound) ~ \(final.upperBound)")
  }
}

