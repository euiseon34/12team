//
//  TaskScoreCalculator.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/3/25.
//

import Foundation

struct TaskData {
  let durationMinutes: Int    // 태스크 예상 소요 시간 (분)
  let importance: Int         // 중요도 (1~5)
  let achievementRate: Double // 달성률 (0.0~1.0)
}

struct TaskScoreCalculator {
  static func calculateScore(for task: TaskData) -> Int {
    let timeScore = timeComponent(task.durationMinutes)
    let importanceScore = importanceComponent(task.importance)
    
    let rawScore = (timeScore + importanceScore)
    let finalScore = rawScore * task.achievementRate
    
    return Int(finalScore.rounded())
  }

  private static func timeComponent(_ minutes: Int) -> Double {
    switch minutes {
    case ..<30: return 5
    case 30..<60: return 10
    case 60..<90: return 20
    default: return 30
    }
  }

  private static func importanceComponent(_ importance: Int) -> Double {
    switch importance {
    case 1: return 5
    case 2: return 10
    case 3: return 15
    case 4: return 20
    case 5: return 25
    default: return 0
    }
  }
}
