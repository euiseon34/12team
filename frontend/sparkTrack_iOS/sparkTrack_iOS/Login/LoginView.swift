//
//  LoginView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/2/25.
//

import SwiftUI

struct LoginView: View {
  @State private var username = ""
  @State private var password = ""
  @State private var navigateToMain = false
  
  var body: some View {
    VStack(spacing: 20) {
      Text("로그인")
        .font(.largeTitle)
        .bold()
      
      TextField("아이디", text: $username)
        .textFieldStyle(.roundedBorder)
        .autocapitalization(.none)
      
      SecureField("비밀번호", text: $password)
        .textFieldStyle(.roundedBorder)
      
      Button("로그인") {
        handleLogin()
      }
      .padding()
      
      NavigationLink(destination: TabBarView(), isActive: $navigateToMain) {
        EmptyView()
      }
    }
    .padding()
  }
  
  private func handleLogin() {
    print("로그인 시도: \(username)")
    // 로그인 성공 시 메인 탭 화면으로
    navigateToMain = true
  }
}


#Preview {
    LoginView()
}
