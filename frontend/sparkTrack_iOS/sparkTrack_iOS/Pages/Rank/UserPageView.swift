//
//  UserPageView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct UserPageView: View {
  @AppStorage("userEmail") var userEmail: String = ""
  @Environment(\.dismiss) var dismiss
  @State private var showLogoutAlert = false
  @State private var navigateToLogin = false
  @State private var navigateToRankList = false

  // 예시 랭크, 임의의 값이라 서버에서 받아와야 함
  let userRank: String = "gold"
  let userScore: Int = 1730
  let userPosition: Int = 4

  var body: some View {
    NavigationView {
      VStack(spacing: 24) {
        Text("👤 마이페이지")
          .font(.title)
          .bold()

        VStack(spacing: 8) {
          Text("이메일")
            .font(.subheadline)
            .foregroundColor(.gray)
          Text(userEmail.isEmpty ? "로그인 정보 없음" : userEmail)
            .font(.body)
            .bold()
        }

        Divider()

        VStack(spacing: 12) {
          Text("🏆 나의 랭크")
            .font(.headline)

          Image("\(userRank)") // bronze, silver, gold, diamond 중 하나
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)

          Text("\(userRank.capitalized) (\(userScore)점)")
            .font(.title3)
            .fontWeight(.medium)

          Text("현재 순위: \(userPosition)위")
            .font(.subheadline)
            .foregroundColor(.gray)

          Button {
            navigateToRankList = true
          } label: {
            Text("랭킹 전체 보기")
              .font(.subheadline)
              .padding(.horizontal, 20)
              .padding(.vertical, 10)
              .background(Color.blue.opacity(0.1))
              .cornerRadius(10)
          }
        }

        Divider()

        Button(role: .destructive) {
          showLogoutAlert = true
        } label: {
          Text("로그아웃")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.1))
            .foregroundColor(.red)
            .cornerRadius(12)
        }
        .padding(.horizontal)

        NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
          EmptyView()
        }

        NavigationLink(destination: RankListView(), isActive: $navigateToRankList) {
          EmptyView()
        }
      }
      .padding()
      .navigationBarBackButtonHidden(true)
      .alert("로그아웃 하시겠습니까?", isPresented: $showLogoutAlert) {
        Button("취소", role: .cancel) {}
        Button("로그아웃", role: .destructive) {
          logout()
        }
      }
    }
  }

  private func logout() {
    SessionManager.shared.clearAuthToken()
    userEmail = ""
    navigateToLogin = true
  }
}


#Preview {
    UserPageView()
}
