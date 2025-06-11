//
//  ConstellationView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/3/25.
//

//
//  ConstellationView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/3/25.
//

import Foundation
import SwiftUI
import Combine

struct ConstellationStar: Identifiable {
  let id = UUID()
  let position: CGPoint
  var isFilled: Bool
}

class ConstellationViewModel: ObservableObject {
  static let shared = ConstellationViewModel()

  // ✅ AppStorage - 점수 저장 및 로그 출력
  @AppStorage("totalScore") var score: Int = 0 {
    willSet { print("💾 [AppStorage] totalScore 변경: \(score) → \(newValue)") }
  }

  @AppStorage("gaugeScore") var currentScore: Int = 0 {
    willSet { print("💾 [AppStorage] gaugeScore 변경: \(currentScore) → \(newValue)") }
  }

  @Published var stars: [ConstellationStar]
  @Published var showCelebration = false

  init() {
    // 북두칠성 7개 국자 모양 배치
    self.stars = [
      ConstellationStar(position: CGPoint(x: 50, y: 150), isFilled: true),
      ConstellationStar(position: CGPoint(x: 80, y: 170), isFilled: true),
      ConstellationStar(position: CGPoint(x: 110, y: 170), isFilled: true),
      ConstellationStar(position: CGPoint(x: 140, y: 120), isFilled: false), // 원래 70 → 120
      ConstellationStar(position: CGPoint(x: 180, y: 140), isFilled: false),
      ConstellationStar(position: CGPoint(x: 210, y: 170), isFilled: false),
      ConstellationStar(position: CGPoint(x: 250, y: 170), isFilled: false)
    ]
    restoreFilledStars()
  }

  /// ✅ 점수 추가 → 별 채우기 + 애니메이션
  func addScore(_ points: Int) {
    score += points
    currentScore += points
    print("🌟 [Constellation] 점수 추가: +\(points) → 총점 \(score), 게이지 \(currentScore)/100")

    while currentScore >= 100 {
      currentScore -= 100
      fillNextStar()
    }

    if stars.allSatisfy({ $0.isFilled }) {
      showCelebration = true
      print("🎉 [Constellation] 별자리 완성 → 축하 애니메이션")

      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        self.reset()
      }
    }
  }

  /// ✅ 별 하나 채우기
  private func fillNextStar() {
    if let index = stars.firstIndex(where: { !$0.isFilled }) {
      stars[index].isFilled = true
      print("⭐️ [Constellation] 별 채워짐 → index \(index)")
    }
  }

  /// ✅ 전체 초기화
  func reset() {
    score = 0
    currentScore = 0
    for i in 0..<stars.count {
      stars[i].isFilled = false
    }
    showCelebration = false
    print("🔄 [Constellation] 전체 리셋 완료")
  }

  /// ✅ 저장된 점수 기반 별 채우기 (앱 실행 시)
  private func restoreFilledStars() {
    let filled = min(score / 100, stars.count)
    for i in 0..<stars.count {
      stars[i].isFilled = i < filled
    }
    print("♻️ [Constellation] 별 상태 복원 완료 → \(filled)개 채워짐")
  }
}

// MARK: - 프리뷰
#Preview {
  let vm = ConstellationViewModel()
  vm.reset()
  vm.addScore(270) // ⭐️ 테스트 점수
  return BigDipperView(viewModel: vm)
}
