//
//  ProgressTrackView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/8/25.
//

import SwiftUI

struct ProgressTrackView: View {
    var body: some View {
      Circle()
        .fill(Color.clear)
        .frame(width: 250, height: 250)
        .overlay(
          Circle().stroke(Color.yellow, lineWidth: 15)
        )
    }
}

#Preview {
  ProgressTrackView()
}
