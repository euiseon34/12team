//
//  RankListView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/30/25.
//

import SwiftUI

struct RankListView: View {
  @State private var rankUsers: [RankUser]
  @State private var isLoading: Bool
  @State private var errorMessage: String?
  
  init(rankUsers: [RankUser] = [], isLoading: Bool = true) {
    _rankUsers = State(initialValue: rankUsers)
    _isLoading = State(initialValue: isLoading)
  }

  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [.black, .purple.opacity(0.8), .blue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      StarryRankBackground()

      VStack(spacing: 20) {
        Text("전체 랭킹")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .padding(.top, 16)

        if isLoading {
          ProgressView("로딩 중...")
            .foregroundColor(.white)
        } else if let error = errorMessage {
          Text("❌ 오류: \(error)")
            .foregroundColor(.red)
        } else {
          ScrollView {
            VStack(spacing: 12) {
              ForEach(rankUsers.indices, id: \.self) { index in
                let user = rankUsers[index]
                HStack(spacing: 16) {
                  Image(user.rank)
                    .resizable()
                    .frame(width: 36, height: 36)

                  VStack(alignment: .leading, spacing: 4) {
                    Text("\(index + 1)위 • \(user.email)")
                      .font(.headline)
                      .foregroundStyle(.white)
                    Text("✨ \(user.score)점")
                      .font(.caption)
                      .foregroundStyle(.white.opacity(0.7))
                  }

                  Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(color: .white.opacity(0.1), radius: 4)
              }
            }
            .padding()
          }
        }
      }
    }
    .onAppear {
      if rankUsers.isEmpty {
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

struct StarryRankBackground: View {
  @State private var twinkle = false

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ForEach(0..<70, id: \.self) { _ in
          Circle()
            .fill(Color.white.opacity(.random(in: 0.3...0.8)))
            .frame(width: CGFloat.random(in: 1.5...3.5))
            .position(
              x: CGFloat.random(in: 0...geometry.size.width),
              y: CGFloat.random(in: 0...geometry.size.height)
            )
            .opacity(twinkle ? 1 : 0.2)
            .animation(
              .easeInOut(duration: Double.random(in: 1.0...2.0)).repeatForever(autoreverses: true),
              value: twinkle
            )
        }
      }
      .onAppear {
        twinkle.toggle()
      }
    }
  }
}

#Preview {
  RankListView(
    rankUsers: [
      RankUser(email: "star1@space.com", score: 920, rank: "diamond"),
      RankUser(email: "sunny@space.com", score: 820, rank: "gold"),
      RankUser(email: "breeze@space.com", score: 700, rank: "silver"),
      RankUser(email: "moon@space.com", score: 610, rank: "bronze")
    ],
    isLoading: false
  )
}
