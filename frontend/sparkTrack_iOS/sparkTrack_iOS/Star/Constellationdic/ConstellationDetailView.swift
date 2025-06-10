//
//  ConstellationDetailView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/10/25.
//

import SwiftUI

// ⭐️ 별자리 상세 뷰
struct ConstellationDetailView: View {
    let stars: [ConstellationStar]
    let title: String
    @State private var animateGradient = false
    @State private var twinkle = false

    var body: some View {
        ZStack {
            // ⭐️ 배경 별들
            StarFieldView(starCount: 80)

            // ⭐️ 전체 별자리 연결선 (희미한 배경선)
            if stars.count > 1 {
                Path { path in
                    path.move(to: stars[0].position)
                    for star in stars.dropFirst() {
                        path.addLine(to: star.position)
                    }
                }
                .stroke(Color.white.opacity(0.3), lineWidth: 6)
            }

            // ✨ 채워진 별들만 연결된 애니메이션 선
            if stars.contains(where: { $0.isFilled }) {
                AnimatedConstellationLine(stars: stars, animate: $animateGradient)
                    .frame(width: 300, height: 300)
            }

            // 🌟 별 UI (빛나는 효과 추가 ⭐️)
            ForEach(0..<stars.count, id: \.self) { index in
                Circle()
                    .fill(stars[index].isFilled ? Color.yellow : Color.gray.opacity(0.4))
                    .frame(width: 20, height: 20)
                    .scaleEffect(twinkle && stars[index].isFilled ? 1.2 : 1.0)
                    .opacity(twinkle && stars[index].isFilled ? 1.0 : 0.8)
                    .position(stars[index].position)
                    .shadow(color: .white, radius: stars[index].isFilled ? 5 : 0)
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 1.0...1.5))
                            .repeatForever(autoreverses: true),
                        value: twinkle
                    )
            }

            // ⭐️ 별자리 이름 (중앙 상단)
            VStack {
                Text("⭐️ \(title) ⭐️")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .opacity(0.8)

                Spacer()
            }
        }
        .frame(width: 300, height: 300)
        .background(Color.black)
        .clipShape(Circle())
        .onAppear {
            animateGradient = true
            twinkle = true
        }
    }
}

// ⭐️ 배경 별들 뷰
struct StarFieldViewinConstellationLine: View {
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

// ⭐️ 애니메이션 선 뷰
struct AnimatedConstellationLineinConstellation: View {
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
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animate)
        }
    }
}

#Preview {
    ConstellationDetailView(
        stars: [
            ConstellationStar(position: CGPoint(x: 50, y: 100), isFilled: true),
            ConstellationStar(position: CGPoint(x: 80, y: 120), isFilled: true),
            ConstellationStar(position: CGPoint(x: 110, y: 120), isFilled: true),
            ConstellationStar(position: CGPoint(x: 140, y: 70), isFilled: true),
            ConstellationStar(position: CGPoint(x: 180, y: 90), isFilled: false),
            ConstellationStar(position: CGPoint(x: 210, y: 120), isFilled: false),
            ConstellationStar(position: CGPoint(x: 250, y: 120), isFilled: false)
        ],
        title: "북두칠성"
    )
}
