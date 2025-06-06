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
      VStack(spacing: 32) {
        Text("🌟 북두칠성 별자리")
          .font(.title)
          .bold()
          .padding(.top, 20)

        BigDipperView(viewModel: viewModel)
          .frame(height: 240)
          .padding(.top, 20)

        ProgressGaugeBarView(currentScore: $viewModel.currentScore)
          .padding(.top, 20)

//        Button("점수 +15 (임시)") {
//          viewModel.addScore(15)
//        }
//        .buttonStyle(.borderedProminent)

        Spacer()
      }
      .padding(.horizontal)

      // 🎉 축하 애니메이션은 ZStack 위에 덮어씌우기
      if viewModel.showCelebration {
        CelebrationView(isVisible: $viewModel.showCelebration)
          .transition(.opacity.combined(with: .scale))
      }
    }
    .animation(.easeInOut(duration: 0.4), value: viewModel.showCelebration)
  }
}

#Preview {
  BigDipperView(viewModel: ConstellationViewModel.shared)
}
