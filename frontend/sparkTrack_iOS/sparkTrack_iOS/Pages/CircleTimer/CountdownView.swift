//
//  CountdownView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/8/25.
//

import SwiftUI

struct CountdownView: View {
  @Environment(\.dismiss) var dismiss
  @State var counter: Int = 0
  var countTo: Int
  var onComplete: (Int) -> Void

  var body: some View {
    VStack {
      ZStack {
        ProgressTrackView()
        ProgressBarView(counter: counter, countTo: countTo)
        ClockView(counter: counter, countTo: countTo)
      }

      Button("⏹️ 종료") {
        onComplete(counter)
        dismiss()
      }
      .padding()
    }
    .onReceive(timer) { _ in
      if counter < countTo {
        counter += 1
      }
    }
  }
}


#Preview {
  CountdownView(countTo: 30) { seconds in
    print("⏰ 타이머 종료: \(seconds)초 진행됨")
  }
}
