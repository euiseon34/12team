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
        // ZStack으로 링 차트 + 별자리 감싸기
        ZStack {
          // 링 차트 → BigDipperView보다 조금 더 크게 + 선 더 두껍게
          RingChartView(progress: Double(viewModel.currentScore) / 100.0)
            .frame(width: 260, height: 260)
            .zIndex(0) // 링 차트가 아래 깔림

          // 별자리 뷰
          BigDipperView(viewModel: viewModel)
            .frame(width: 240, height: 240)
            .zIndex(1) // 별자리는 위에
        }
        .padding(.top, 10)

//        // ✅ 테스트용 버튼 (링 차트 채우는 테스트)
//        Button(action: {
//          viewModel.addScore(10)
//        }) {
//          Text("+10점 추가 (테스트)")
//            .font(.subheadline)
//            .foregroundColor(.white)
//            .padding(.horizontal, 16)
//            .padding(.vertical, 8)
//            .background(Color.blue)
//            .cornerRadius(8)
//        }
//        .padding(.top, 12)

        Spacer()
      }
      .frame(maxHeight: UIScreen.main.bounds.height * 0.45)
      .padding(.horizontal)

      // ✅ 축하 애니메이션 → 화면 전체 덮기 + safe area 무시
      if viewModel.showCelebration {
        CelebrationView(isVisible: $viewModel.showCelebration)
          .ignoresSafeArea()
          .transition(.opacity.combined(with: .scale))
          .zIndex(100) // 항상 최상단
      }
    }
    .animation(.easeInOut(duration: 0.4), value: viewModel.showCelebration)
  }
}

struct RingChartView: View {
  var progress: Double
  @State private var isGlowing = false

  var body: some View {
    ZStack {
      // 배경 Circle
      Circle()
        .stroke(Color.white.opacity(0.1), lineWidth: 20)

      // Progress Circle
      Circle()
        .trim(from: 0, to: progress)
        .stroke(
          AngularGradient(
            gradient: Gradient(colors: [
              Color.yellow,
              Color.purple.opacity(0.8),
              Color.blue.opacity(0.8),
              Color.yellow
            ]),
            center: .center
          ),
          style: StrokeStyle(lineWidth: 60, lineCap: .round)
        )
        .rotationEffect(.degrees(-90))
        .shadow(color: Color.yellow.opacity(0.5), radius: 10)
        .shadow(color: Color.purple.opacity(0.3), radius: 6)
        .scaleEffect(isGlowing ? 1.02 : 1.0)
        .opacity(isGlowing ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isGlowing)
        .onAppear {
          isGlowing = true
        }

      // 중앙 Text 표시
      VStack(spacing: 4) {
        Text("게이지")
          .font(.caption)
          .foregroundColor(.white.opacity(0.6))
        Text("\(Int(progress * 100))%")
          .font(.title2)
          .fontWeight(.semibold)
          .foregroundColor(.white)
      }
    }
    .frame(width: 260, height: 260)
    .padding()
  }
}

#Preview {
  ConstellationBoardView(viewModel: ConstellationViewModel.shared)
}
