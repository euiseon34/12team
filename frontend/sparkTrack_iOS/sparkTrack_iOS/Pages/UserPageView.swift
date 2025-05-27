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

      }
      .padding()
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
  }
}

#Preview {
    UserPageView()
}
