//
//  ConstellationBoardViewReusable.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/11/25.
//

import SwiftUI

import SwiftUI

struct ConstellationBoardViewReusable: View {
  let stars: [ConstellationStar]
  @Binding var animateGradient: Bool
  
  var body: some View {
    ZStack {
      StarFieldView(starCount: 60)
      
      // 전체 별자리 연결선
      if stars.count > 1 {
        Path { path in
          path.move(to: stars[0].position)
          for star in stars.dropFirst() {
            path.addLine(to: star.position)
          }
        }
        .stroke(Color.white.opacity(0.3), lineWidth: 6)
      }
      
      // 채워진 별들만 연결된 애니메이션 선
      if stars.contains(where: { $0.isFilled }) {
        AnimatedConstellationLine(stars: stars, animate: $animateGradient)
          .frame(width: 300, height: 300)
      }
      
      // 별 UI
      ForEach(stars.indices, id: \.self) { index in
        Circle()
          .fill(stars[index].isFilled ? Color.yellow : Color.gray.opacity(0.4))
          .frame(width: 20, height: 20)
          .position(stars[index].position)
          .shadow(color: .white, radius: stars[index].isFilled ? 5 : 0)
      }
    }
    .frame(width: 300, height: 300)
    .background(Color.black)
    .clipShape(Circle())
  }
}

struct StarFieldView: View {
  let starCount: Int
  @State private var twinkle = false
  
  struct Star: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let delay: Double
  }
  
  let stars: [Star]
  
  init(starCount: Int) {
    self.starCount = starCount
    self.stars = (0..<starCount).map { _ in
      Star(
        x: CGFloat.random(in: 0...300),
        y: CGFloat.random(in: 0...300),
        size: CGFloat.random(in: 1...3),
        delay: Double.random(in: 0...1)
      )
    }
  }
  
  var body: some View {
    ZStack {
      ForEach(stars) { star in
        Circle()
          .fill(Color.white.opacity(0.8))
          .frame(width: star.size, height: star.size)
          .position(x: star.x, y: star.y)
          .opacity(twinkle ? 0.3 : 1.0)
          .animation(
            Animation.easeInOut(duration: 1.5)
              .repeatForever()
              .delay(star.delay),
            value: twinkle
          )
      }
    }
    .onAppear {
      twinkle.toggle()
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
        let filledStars = stars.filter { $0.isFilled }
        if filledStars.count >= 2 {
          path.move(to: filledStars[0].position)
          for star in filledStars.dropFirst() {
            path.addLine(to: star.position)
          }
        }
      }
      .stroke(gradient, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
//      .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animate)
    }
  }
}

#Preview {
  ConstellationBoardViewReusable(
    stars: [
        ConstellationStar(position: CGPoint(x: 50, y: 150), isFilled: true),
        ConstellationStar(position: CGPoint(x: 80, y: 170), isFilled: true),
        ConstellationStar(position: CGPoint(x: 110, y: 170), isFilled: true),
        ConstellationStar(position: CGPoint(x: 140, y: 120), isFilled: false), // 원래 70 → 120
        ConstellationStar(position: CGPoint(x: 180, y: 140), isFilled: false),
        ConstellationStar(position: CGPoint(x: 210, y: 170), isFilled: false),
        ConstellationStar(position: CGPoint(x: 250, y: 170), isFilled: false)
        ],
    animateGradient: .constant(true) // ⭐️ Preview용 바인딩
  )
}
