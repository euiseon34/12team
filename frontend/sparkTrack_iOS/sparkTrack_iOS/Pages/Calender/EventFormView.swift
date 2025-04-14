//
//  EventFormView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/14/25.
//

import SwiftUI

struct EventFormView: View {
  let date: Date
  var onSave: (String) -> Void
  @Environment(\.dismiss) private var dismiss
  @State private var title: String = ""
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("선택한 날짜")) {
          Text(date.formatted(date: .abbreviated, time: .omitted))
        }
        
        Section(header: Text("일정 제목")) {
          TextField("제목 입력", text: $title)
        }
      }
      .navigationTitle("일정 추가")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("추가") {
            onSave(title)
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
    date: Date(),
    onSave: { title in
      print("Saved event with title: \(title)")
    }
  )
}
