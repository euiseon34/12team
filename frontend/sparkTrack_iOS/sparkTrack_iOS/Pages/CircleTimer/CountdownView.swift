//
//  CountdownView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/8/25.
//

import SwiftUI

struct CountdownView: View {
  @State var counter: Int = 0
  var countTo: Int = 120
  
  var body: some View {
    VStack{
      ZStack{
        ProgressTrackView()
        ProgressBarView(counter: counter, countTo: countTo)
        ClockView(counter: counter, countTo: countTo)
      }
    }
    .onReceive(timer) { time in
      if (self.counter < self.countTo) {
        self.counter += 1
      }
    }
  }
}

#Preview {
    CountdownView()
}
