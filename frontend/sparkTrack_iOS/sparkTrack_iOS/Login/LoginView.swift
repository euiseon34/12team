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
  @State private var isLoggedIn = false
  
  var body: some View {
    VStack(spacing: 20) {
      Text("로그인")
        .font(.largeTitle)
        .bold()
      
      TextField("아이디", text: $username)
        .textFieldStyle(.roundedBorder)
      
      SecureField("비밀번호", text: $password)
        .textFieldStyle(.roundedBorder)
      
      Button("로그인") {
        // 서버 연동 후 성공 시 isLoggedIn = true
        isLoggedIn = true
      }
      .padding()
      .buttonStyle(.borderedProminent)
      
      NavigationLink("", destination: TabBarView(), isActive: $isLoggedIn)
        .hidden()
    }
    .padding()
  }
}


#Preview {
    LoginView()
}
