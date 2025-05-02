//
//  TaskManagerView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/18/25.
//

import SwiftUI

struct TaskManagerView: View {
  @State private var tasks: [Task] = []
  @State private var selectedDate = Date()
  @State private var showEventForm = false
  
  var body: some View {
    VStack(spacing: 20) {
      Button("➕ 일정 추가") {
        showEventForm = true
      }
      
      // 여기서 매트릭스에 전달
      UrgencyPreferenceMatrixView(tasks: tasks)
    }
    .sheet(isPresented: $showEventForm) {
      EventFormView(selectedDate: $selectedDate) { title, description, category, start, end, importance, preference  in
        let newTask = Task(title: title, urgency: importance, preference: preference)
        tasks.append(newTask)
      }
    }
  }
}

#Preview {
    TaskManagerView()
}
