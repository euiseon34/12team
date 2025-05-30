//
//  RankUser.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/30/25.
//

import SwiftUI
import Foundation

struct RankUser: Identifiable, Codable {
    var id: UUID = UUID()
    let email: String
    let score: Int
    let rank: String  // "bronze", "silver", "gold", "diamond"
}
