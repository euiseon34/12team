//
//  ConstellationBoardView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/3/25.
//

import SwiftUI

struct ConstellationBoardView: View {
  @ObservedObject var viewModel: ConstellationViewModel

  var body: some View {
    ZStack {
      VStack(spacing: 12) {
        // 기존 제목 제거

        ZStack {
          // 별자리에 원형 게이지 추가
          CircularGaugeBackground(progress: CGFloat(viewModel.currentScore) / 100.0)
            .frame(width: 240, height: 240)

          BigDipperView(viewModel: viewModel)
            .frame(width: 240, height: 240)
        }
        .padding(.top, 10)

        Spacer() // 투두와 간격 주기

        // 축하 애니메이션 ZStack 위에 덮어씌우기
        if viewModel.showCelebration {
          CelebrationView(isVisible: $viewModel.showCelebration)
            .transition(.opacity.combined(with: .scale))
        }
      }
      .frame(maxHeight: UIScreen.main.bounds.height * 0.45) // 상단 45% 정도 영역 사용
      .padding(.horizontal)
    }
    .animation(.easeInOut(duration: 0.4), value: viewModel.showCelebration)
  }
}

struct CircularGaugeBackground: View {
  var progress: CGFloat // 0.0 ~ 1.0
  
  var body: some View {
    Circle()
      .trim(from: 0, to: progress)
      .stroke(
        AngularGradient(
          gradient: Gradient(colors: [.yellow, .yellow.opacity(0.5), .clear]),
          center: .center
        ),
        style: StrokeStyle(lineWidth: 8, lineCap: .round)
      )
      .rotationEffect(.degrees(-90))
      .animation(.easeInOut(duration: 0.5), value: progress)
  }
}

#Preview {
  BigDipperView(viewModel: ConstellationViewModel.shared)
}
