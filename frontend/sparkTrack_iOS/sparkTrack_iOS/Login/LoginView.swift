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
  @State private var navigateToSignUp = false
  @AppStorage("userEmail") var userEmail: String = ""
  
  var body: some View {
    NavigationView {
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
        
        // 회원가입 버튼
        NavigationLink(destination: SignUpView(), isActive: $navigateToSignUp) {
          Button("회원가입") {
            navigateToSignUp = true
          }
          .padding(.top, 10)
        }
        
        // 메인화면으로 이동
        NavigationLink(destination: TabBarView(), isActive: $navigateToMain) {
          EmptyView()
        }
        .navigationBarBackButtonHidden(true)
      }
      .padding()
    }
  }
  
  private func handleLogin() {
    AuthService.shared.login(email: username, password: password) { token in
      DispatchQueue.main.async {
        if let token = token {
          SessionManager.shared.saveAuthToken(token)
          userEmail = username  // ✅ 이메일 저장!
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
