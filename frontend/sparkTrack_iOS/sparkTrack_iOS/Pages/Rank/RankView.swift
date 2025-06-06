//
//  RankView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/6/25.
//

import SwiftUI

struct UserRank: Identifiable {
  let id = UUID()
  let username: String
  let score: Int
  let rank: Int
  let badge: String
}

struct RankView: View {
  let users: [UserRank]
  let currentUser: UserRank?

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("🏆 나의 랭크")
        .font(.title2)
        .bold()
        .padding(.top)

      if let me = currentUser {
        HStack {
          Text("\(me.rank)위")
            .font(.title3)
            .bold()
          Text(me.username)
          Spacer()
          Text(me.badge)
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(12)
      }

      Divider()

      Text("📋 전체 유저 랭킹")
        .font(.headline)

      ForEach(users.prefix(10)) { user in
        HStack {
          Text("\(user.rank)위")
            .frame(width: 50, alignment: .leading)
          Text(user.username)
          Spacer()
          Text(user.badge)
        }
        .padding(.vertical, 6)
      }

      Spacer()
    }
    .padding()
  }
}

#Preview {
  RankView(
    users: [
      UserRank(username: "별빛", score: 720, rank: 1, badge: "💎 Diamond"),
      UserRank(username: "햇살", score: 650, rank: 2, badge: "🥇 Gold"),
      UserRank(username: "바람", score: 580, rank: 3, badge: "🥈 Silver"),
      UserRank(username: "파랑새", score: 470, rank: 4, badge: "🥉 Bronze"),
      UserRank(username: "코코", score: 410, rank: 5, badge: "🥉 Bronze"),
    ],
    currentUser: UserRank(username: "코코", score: 410, rank: 5, badge: "🥉 Bronze")
  )
}
