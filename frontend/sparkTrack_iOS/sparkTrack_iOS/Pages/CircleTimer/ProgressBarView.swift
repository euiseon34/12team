//
//  ProgressBarView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/8/25.
//

import SwiftUI

struct ProgressBarView: View {
  @State private var isExpanded = false
  
  var counter: Int
  var countTo: Int
  
  func complete() -> Bool {
    return progress() == 1
  }
  
  func progress() -> CGFloat {
    return (CGFloat(counter) / CGFloat(countTo))
  }
  
  var body: some View {
    Circle()
      .fill(Color.clear)
      .frame(width: 250, height: 250)
      .overlay(
        Circle().trim(from: 0, to: progress())
          .stroke(
            style: StrokeStyle(
              lineWidth: 15,
              lineCap: .round,
              lineJoin: .round
            )
          )
          .foregroundStyle(
            complete() ? Color.yellow : Color.gray
          )
          .animation(.easeInOut(duration: 0.2), value: isExpanded)
      )
  }
}

#Preview {
  ProgressBarView(counter: 30, countTo: 50)
}
