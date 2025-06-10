//
//  ConstellationEntry.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/10/25.
//

import SwiftUI

struct ConstellationEntry: Identifiable {
  let id = UUID()
  let name: String
  let isCompleted: Bool
  let stars: [ConstellationStar]
}
