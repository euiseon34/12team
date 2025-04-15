//
//  QuadrantView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/15/25.
//

import SwiftUI

struct QuadrantTask: Identifiable {
    let id = UUID()
    let title: String
    let isImportant: Bool
    let isUrgent: Bool
}

struct QuadrantView: View {
  let tasks: [QuadrantTask]
  
  var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 8) {
        quadrantBox(title: "긴급 & 중요", color: .red.opacity(0.1),
                    tasks: tasks.filter { $0.isUrgent && $0.isImportant })
        quadrantBox(title: "긴급 & 덜 중요", color: .orange.opacity(0.1),
                    tasks: tasks.filter { $0.isUrgent && !$0.isImportant })
      }
      HStack(spacing: 8) {
        quadrantBox(title: "비긴급 & 중요", color: .blue.opacity(0.1),
                    tasks: tasks.filter { !$0.isUrgent && $0.isImportant })
        quadrantBox(title: "비긴급 & 덜 중요", color: .gray.opacity(0.1),
                    tasks: tasks.filter { !$0.isUrgent && !$0.isImportant })
      }
    }
    .padding()
  }
  
  func quadrantBox(title: String, color: Color, tasks: [QuadrantTask]) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.headline)
        .padding(6)
        .frame(maxWidth: .infinity)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      
      ForEach(tasks) { task in
        Text("• \(task.title)")
          .padding(.horizontal, 6)
          .padding(.vertical, 2)
          .background(Color.white)
          .cornerRadius(6)
      }
      
      Spacer()
    }
    .padding()
    .frame(maxWidth: .infinity, minHeight: 160)
    .background(color)
    .cornerRadius(12)
    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
  }
}

#Preview {
  QuadrantView(tasks: [
    QuadrantTask(title: "과제 제출", isImportant: true, isUrgent: true),
    QuadrantTask(title: "회의 준비", isImportant: true, isUrgent: false),
    QuadrantTask(title: "이메일 확인", isImportant: false, isUrgent: true),
    QuadrantTask(title: "운동하기", isImportant: false, isUrgent: false)
  ])
}
