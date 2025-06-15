//
//  CountdownView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/8/25.
//

import SwiftUI

struct CountdownView: View {
  @Environment(\.dismiss) var dismiss

  @State private var elapsedTime: Int = 0
  @State private var timerStartDate: Date? = nil
  @State private var isRunning: Bool = false
  @State private var timer: Timer? = nil

  var countTo: Int
  var onComplete: (Int) -> Void

  var remainingTime: Int {
    max(countTo - elapsedTime, 0)
  }

  var body: some View {
    ZStack {
      // 배경: 우주 밤하늘
      LinearGradient(
        gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
        startPoint: .top,
        endPoint: .bottom
      )
      .edgesIgnoringSafeArea(.all)
      .overlay(
        StarryBackground()
      )

      VStack(spacing: 40) {
        ZStack {
          ProgressTrackView()
          ProgressBarView(counter: elapsedTime, countTo: countTo)
          ClockView(counter: elapsedTime, countTo: countTo)
        }
        .frame(width: 260, height: 260)

        HStack(spacing: 30) {
          Button {
            isRunning ? pauseTimer() : startTimer()
          } label: {
            Text(isRunning ? "⏸️ 일시정지" : (elapsedTime == 0 ? "▶️ 시작" : "▶️ 다시 시작"))
              .font(.headline)
              .padding(.horizontal, 24)
              .padding(.vertical, 12)
              .background(.ultraThinMaterial)
              .foregroundStyle(.white)
              .clipShape(Capsule())
          }

          Button {
            timer?.invalidate()
            timer = nil
            isRunning = false
            onComplete(elapsedTime)
            dismiss()
          } label: {
            Text("⏹️ 종료")
              .font(.headline)
              .padding(.horizontal, 24)
              .padding(.vertical, 12)
              .background(Color.red.opacity(0.8))
              .foregroundStyle(.white)
              .clipShape(Capsule())
          }
        }
      }
      .padding(.bottom, 50)
    }
    .onDisappear {
      timer?.invalidate()
      timer = nil
    }
  }

  private func startTimer() {
    timerStartDate = Date()
    isRunning = true

    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      guard timerStartDate != nil else { return }

      elapsedTime += 1

      if elapsedTime >= countTo {
        timer?.invalidate()
        timer = nil
        isRunning = false
        onComplete(countTo)
        dismiss()
      }

      timerStartDate = Date() // 기준점 갱신
    }
  }

  private func pauseTimer() {
    timer?.invalidate()
    timer = nil
    isRunning = false
  }
}

struct StarryBackground: View {
  @State private var twinkle = false

  var body: some View {
    ZStack {
      ForEach(0..<60, id: \.self) { i in
        Circle()
          .fill(Color.white.opacity(.random(in: 0.3...0.8)))
          .frame(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 1...3))
          .position(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
          )
          .opacity(twinkle ? 1 : 0.3)
          .animation(
            .easeInOut(duration: Double.random(in: 1.0...2.5)).repeatForever(autoreverses: true),
            value: twinkle
          )
      }
    }
    .onAppear {
      twinkle.toggle()
    }
  }
}


#Preview {
  CountdownView(countTo: 30) { seconds in
    print("⏰ 타이머 종료: \(seconds)초 진행됨")
  }
}
