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
      AuthService.shared.login(email: username, password: password) { token in
        DispatchQueue.main.async {
          if token != nil {
            print("✅ 로그인 성공")
            self.navigateToMain = true
          } else {
            print("❌ 로그인 실패")
          }
        }
      }
    }
}


#Preview {
    LoginView()
}
