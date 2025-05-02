//
//  SignUpView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/2/25.
//

import SwiftUI

struct SignUpView: View {
  @State private var username = ""
  @State private var password = ""
  @State private var email = ""
  @State private var selectedTimePreference = "아침"
  
  let timeOptions = ["아침", "점심", "저녁"]
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("계정 정보")) {
          TextField("아이디", text: $username)
            .autocapitalization(.none)
            .disableAutocorrection(true)
          
          SecureField("비밀번호", text: $password)
          
          TextField("이메일", text: $email)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
        }
        
        Section(header: Text("식사 시간 선호")) {
          Picker("선호 시간", selection: $selectedTimePreference) {
            ForEach(timeOptions, id: \.self) { Text($0) }
          }
          .pickerStyle(.segmented)
        }
        
        Section {
          Button("회원가입") {
            handleSignUp()
          }
        }
      }
      .navigationTitle("회원가입")
    }
  }
  
  private func handleSignUp() {
    // 예시 출력 (API 연동 시 여기에 서버 요청 코드 작성)
    print("아이디: \(username)")
    print("비밀번호: \(password)")
    print("이메일: \(email)")
    print("식사 시간 선호: \(selectedTimePreference)")
  }
}

#Preview {
  SignUpView()
}
