//
//  ClockView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/8/25.
//

import SwiftUI

let timer = Timer
  .publish(every: 1, on: .main, in: .common)
  .autoconnect()

struct ClockView: View {
  var counter: Int
  var countTo: Int
  
  func CounterToMinutes() -> String {
    let currentTime = countTo - counter
    let seconds = currentTime % 60
    let minutes = Int(currentTime / 60)
    
    return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
  }
  
  var body: some View {
    VStack{
      Text(CounterToMinutes())
        .font(.custom("Avenir Next", size: 60))
        .fontWeight(.black)
    }
  }
}

#Preview {
  ClockView(counter: 50, countTo: 30)
}
