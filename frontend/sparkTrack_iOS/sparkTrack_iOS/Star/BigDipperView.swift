//
//  BigDipperView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/3/25.
//

import SwiftUI

struct BigDipperView: View {
  @ObservedObject var viewModel: ConstellationViewModel
  @State private var animateGradient = false

  var body: some View {
    ZStack {
      // ⭐️ 전체 연결 선 (희미한 밑그림)
      if viewModel.stars.count > 1 {
        Path { path in
          path.move(to: viewModel.stars[0].position)
          for star in viewModel.stars.dropFirst() {
            path.addLine(to: star.position)
          }
        }
        .stroke(Color.white.opacity(0.3), lineWidth: 6)
      }

      // ✨ 채워진 별들만 반짝이는 애니메이션 선
      if viewModel.stars.contains(where: { $0.isFilled }) {
        AnimatedConstellationLine(stars: viewModel.stars, animate: $animateGradient)
          .frame(width: 300, height: 300)
      }

      // 🌟 별들
      ForEach(viewModel.stars) { star in
        Circle()
          .fill(star.isFilled ? Color.yellow : Color.gray.opacity(0.4))
          .frame(width: 20, height: 20)
          .position(star.position)
          .shadow(color: .white, radius: star.isFilled ? 5 : 0)
      }
    }
    .offset(y: 50)
    .frame(width: 300, height: 300)
    .background(Color.black)
    .clipShape(Circle())
    .onAppear {
      animateGradient = true
    }
  }
}


struct AnimatedConstellationLine: View {
  let stars: [ConstellationStar]
  @Binding var animate: Bool

  var body: some View {
    TimelineView(.animation) { context in
      let phase = animate
        ? context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 2.0) / 2.0
        : 0.0

      let gradient = LinearGradient(
        gradient: Gradient(colors: [
          .white.opacity(0.1),
          .yellow.opacity(0.6),
          .white.opacity(0.1)
        ]),
        startPoint: UnitPoint(x: phase, y: 0),
        endPoint: UnitPoint(x: phase + 0.3, y: 1)
      )

      Path { path in
        // isFilled == true인 별들만 필터링
        let filledStars = stars.filter { $0.isFilled }
        if filledStars.count >= 2 {
          path.move(to: filledStars[0].position)
          for star in filledStars.dropFirst() {
            path.addLine(to: star.position)
          }
        }
      }
      .stroke(gradient, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
      .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animate)
    }
  }
}

#Preview {
    let viewModel = ConstellationViewModel()
    viewModel.updateProgress(by: 300) // ⭐️ 3개 별 채움
    return BigDipperView(viewModel: viewModel)
}
