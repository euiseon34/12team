//
//  UrgencyPreferenceMatrixView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/18/25.
//

import SwiftUI

struct MatrixTask: Identifiable {
  let id = UUID()
  let title: String
  let urgency: Int
  let preference: Int
}

struct UrgencyPreferenceMatrixView: View {
  let tasks: [MatrixTask]
  
  private let cellSize: CGFloat = 50
  private let columns = Array(repeating: GridItem(.fixed(50), spacing: 4), count: 5)
  
  var body: some View {
    let yAxis = (1...5).reversed()
    let xAxis = (1...5)
    
    return VStack(alignment: .leading, spacing: 6) {
      Text("📊 우선순위 매트릭스")
        .font(.subheadline)
        .fontWeight(.semibold)
        .padding(.leading, 8)
      
      HStack(alignment: .top, spacing: 4) {
        // Y축
        VStack(spacing: 4) {
          ForEach(yAxis, id: \.self) { urgency in
            Text("⚡️\(urgency)")
              .font(.caption2)
              .frame(width: 30, height: cellSize)
          }
        }
        
        // 5x5 고정 셀 매트릭스
        LazyVGrid(columns: columns, spacing: 4) {
          ForEach(yAxis, id: \.self) { urgency in
            ForEach(xAxis, id: \.self) { preference in
              MatrixCell(tasks: tasks, urgency: urgency, preference: preference, cellSize: cellSize)
            }
          }
        }
      }
      
      // X축
      HStack(spacing: 4) {
        Spacer().frame(width: 30)
        ForEach(xAxis, id: \.self) { preference in
          Text("❤️\(preference)")
            .font(.caption2)
            .frame(width: cellSize)
        }
      }
      .padding(.top, 4)
    }
    .frame(width: 350, height: 400)
    .padding(8)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(radius: 2)
  }
}

// 셀 하나 컴포넌트 분리 (컴파일러 최적화에 도움)
struct MatrixCell: View {
  let tasks: [MatrixTask]
  let urgency: Int
  let preference: Int
  let cellSize: CGFloat
  
  var body: some View {
    let filtered = tasks.filter { $0.urgency == urgency && $0.preference == preference }
    
    return VStack(alignment: .leading, spacing: 2) {
      if filtered.isEmpty {
        Spacer()
      } else {
        Text("📌\(filtered.count)")
          .font(.caption2)
          .foregroundColor(.gray)
        
        ForEach(filtered.prefix(1)) { task in
          Text("• \(task.title)")
            .font(.caption2)
            .lineLimit(1)
        }
      }
    }
    .frame(width: cellSize, height: cellSize)
    .background(filtered.isEmpty ? Color.gray.opacity(0.05) : Color.blue.opacity(0.15))
    .overlay(
      RoundedRectangle(cornerRadius: 4)
        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
    )
    .cornerRadius(4)
  }
}

#Preview {
  UrgencyPreferenceMatrixView(tasks: [
    MatrixTask(title: "과제 제출", urgency: 5, preference: 5),
    MatrixTask(title: "이메일 확인", urgency: 5, preference: 4),
    MatrixTask(title: "회의 준비", urgency: 2, preference: 2),
    MatrixTask(title: "운동하기", urgency: 1, preference: 2),
    MatrixTask(title: "책 읽기", urgency: 1, preference: 5),
    MatrixTask(title: "할 일 정리", urgency: 3, preference: 3),
  ])
}
