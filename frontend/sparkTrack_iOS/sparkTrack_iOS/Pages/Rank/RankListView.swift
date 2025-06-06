//
//  RankListView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/30/25.
//

import SwiftUI

struct RankListView: View {
  @State private var rankUsers: [RankUser] = []
  @State private var isLoading = true
  @State private var errorMessage: String?

  var body: some View {
    NavigationView {
      VStack {
        if isLoading {
          ProgressView("로딩 중...")
        } else if let error = errorMessage {
          Text("❌ 오류: \(error)")
            .foregroundColor(.red)
        } else {
          List(rankUsers.indices, id: \.self) { index in
            let user = rankUsers[index]
            HStack(spacing: 16) {
              Image(user.rank)
                .resizable()
                .frame(width: 32, height: 32)

              VStack(alignment: .leading) {
                Text("\(index + 1)위: \(user.email)")
                  .font(.headline)
                Text("점수: \(user.score)")
                  .font(.subheadline)
              }
              Spacer()
            }
            .padding(.vertical, 4)
          }
        }
      }
      .navigationTitle("🏆 전체 랭킹")
      .onAppear {
        loadRankList()
      }
    }
  }

  private func loadRankList() {
    RankService.shared.fetchRankList { result in
      DispatchQueue.main.async {
        isLoading = false
        switch result {
        case .success(let users):
          self.rankUsers = users.sorted { $0.score > $1.score }
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        }
      }
    }
  }
}

#Preview("예시 미리보기") {
  NavigationView {
    RankListView_PreviewWrapper()
  }
}

/// ✅ 서버 없이 미리보기용 Wrapper
struct RankListView_PreviewWrapper: View {
  @State private var dummyUsers: [RankUser] = [
    RankUser(email: "star1@space.com", score: 920, rank: "diamond"),
    RankUser(email: "sunny@space.com", score: 820, rank: "gold"),
    RankUser(email: "breeze@space.com", score: 700, rank: "silver"),
    RankUser(email: "moon@space.com", score: 610, rank: "bronze")
  ]

  var body: some View {
    List(dummyUsers.indices, id: \.self) { index in
      let user = dummyUsers[index]
      HStack(spacing: 16) {
        Image(user.rank)
          .resizable()
          .frame(width: 32, height: 32)

        VStack(alignment: .leading) {
          Text("\(index + 1)위: \(user.email)")
            .font(.headline)
          Text("점수: \(user.score)")
            .font(.subheadline)
        }
        Spacer()
      }
      .padding(.vertical, 4)
    }
    .navigationTitle("🏆 전체 랭킹 (예시)")
  }
}
