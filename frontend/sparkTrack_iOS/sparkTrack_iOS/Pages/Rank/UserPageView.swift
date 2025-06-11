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
  
  // 예시 데이터 (서버 연동 필요)
  let userProfileImageName = "profilePlaceholder" // 임시 프로필 이미지 이름
  let userName = "spark_user" // 유저 ID
  let userRank: String = "gold"
  let userScore: Int = 1730
  
  var body: some View {
    NavigationView {
      ZStack {
        Image("backgroundcolor")
          .resizable()
          .ignoresSafeArea()
          .opacity(0.9)
        
        VStack(spacing: 24) {
          Text("👤 마이페이지")
            .font(.title)
            .bold()
            .foregroundStyle(.white)
          
          // ✅ 프로필 사진
          Circle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
              Image("userProfile")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
            )
            .frame(width: 200, height: 200)
            .shadow(radius: 8)
          
          // ✅ 유저 정보
          VStack(spacing: 8) {
            Text(userName)
              .font(.title3)
              .fontWeight(.medium)
              .foregroundStyle(.white)
            
            Text(userEmail.isEmpty ? "로그인 정보 없음" : userEmail)
              .font(.subheadline)
              .foregroundColor(.gray)
          }
          
          Divider()
          
          // ✅ 랭크 정보 (클릭 시 이동)
          Button {
            navigateToRankList = true
          } label: {
            VStack(spacing: 12) {
              Text("🏆 나의 랭크")
                .font(.headline)
                .foregroundStyle(.white)
              
              Image("gold")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .shadow(radius: 10)
              
              Text("\(userRank.capitalized) (\(userScore)점)")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.white)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
          }
          
//          Spacer()
          
          // ✅ 로그아웃 버튼
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
          
          // NavigationLinks
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
