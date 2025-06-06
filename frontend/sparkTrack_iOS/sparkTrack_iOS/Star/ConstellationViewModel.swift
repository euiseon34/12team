//
//  ConstellationView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/3/25.
//

import SwiftUI
import Combine

struct ConstellationStar: Identifiable {
    let id = UUID()
    let position: CGPoint
    var isFilled: Bool
}

class ConstellationViewModel: ObservableObject {
  static let shared = ConstellationViewModel()
  
  @Published var score: Int = 0
  @Published var currentScore: Int = 0
  @Published var stars: [ConstellationStar]
  @Published var showCelebration = false
  
  init() {
    // 북두칠성 별 7개를 국자 모양으로 배치
    self.stars = [
      ConstellationStar(position: CGPoint(x: 50, y: 100), isFilled: false),
      ConstellationStar(position: CGPoint(x: 80, y: 120), isFilled: false),
      ConstellationStar(position: CGPoint(x: 110, y: 120), isFilled: false),
      ConstellationStar(position: CGPoint(x: 140, y: 70), isFilled: false),
      ConstellationStar(position: CGPoint(x: 180, y: 90), isFilled: false),
      ConstellationStar(position: CGPoint(x: 210, y: 120), isFilled: false),
      ConstellationStar(position: CGPoint(x: 250, y: 120), isFilled: false)
    ]
  }
  
  func updateProgress(by points: Int) {
    score += points
    
    let filledStars = min(score / 100, stars.count)
    
    for i in 0..<stars.count {
      stars[i].isFilled = i < filledStars
    }
  }
  
  func addScore(_ points: Int) {
    // 전체 누적 점수
    score += points
    
    // 현재 게이지 점수 (0~100 사이)
    currentScore += points
    if currentScore >= 100 {
      currentScore -= 100 // 게이지 초기화

      fillNextStar()

      // 별이 모두 찼다면 축하 애니메이션 → 리셋
      if stars.allSatisfy({ $0.isFilled }) {
        showCelebration = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
          self.reset()
        }
      }
    }
  }

  
  private func fillNextStar() {
    if let index = stars.firstIndex(where: { !$0.isFilled }) {
      stars[index].isFilled = true
    }
  }
  
  func reset() {
    score = 0
    for i in 0..<stars.count {
      stars[i].isFilled = false
    }
    showCelebration = false
  }
}

// MARK: - 미리보기
#Preview {
    BigDipperView(viewModel: ConstellationViewModel())
}
