//
//  TaskManagerView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/18/25.
//

import SwiftUI

struct TaskManagerView: View {
  @State private var tasks: [MatrixTask] = []
  @State private var selectedDate = Date()
  @State private var showEventForm = false
  @State private var showMatrix = false  // ✅ 매트릭스 토글 상태

  var body: some View {
    VStack(spacing: 20) {
      Button("➕ 일정 추가") {
        showEventForm = true
      }

      // ✅ 매트릭스 접고 펼치기 버튼
      Button(action: {
        withAnimation {
          showMatrix.toggle()
        }
      }) {
        HStack {
          Image(systemName: showMatrix ? "chevron.down" : "chevron.right")
          Text("우선순위 매트릭스 \(showMatrix ? "접기" : "펼치기")")
        }
        .foregroundColor(.blue)
      }

      // ✅ 매트릭스 본문
      if showMatrix {
        UrgencyPreferenceMatrixView(tasks: tasks)
      }
    }
    .sheet(isPresented: $showEventForm) {
      EventFormView(selectedDate: $selectedDate) { title, description, category, start, end, importance, preference, estimatedDuration, deadline in
        let newTask = MatrixTask(title: title, urgency: importance, preference: preference)
        tasks.append(newTask)
      }
    }
  }
}

#Preview {
  TaskManagerView()
}
