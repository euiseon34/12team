//
//  ProgressGaugeBarView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/3/25.
//

import SwiftUI

struct ProgressGaugeBarView: View {
  @Binding var currentScore: Int

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("게이지: \(currentScore)/100")
        .font(.caption)
        .foregroundColor(.gray)
        .padding(.leading)

      ProgressView(value: Float(currentScore), total: 100)
        .progressViewStyle(.linear)
        .tint(.yellow)
        .frame(height: 12)
        .padding(.horizontal)
    }
  }
}

#Preview {
  StatefulPreviewWrapper(75) { value in
    ProgressGaugeBarView(currentScore: value)
  }
}
