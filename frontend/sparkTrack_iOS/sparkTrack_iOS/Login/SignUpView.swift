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
  @State private var showSuccessAlert = false
  
  @Environment(\.dismiss) private var dismiss
  
  let timeOptions = ["아침", "점심", "저녁", "새벽"]
  
  var body: some View {
    VStack {
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
        
        Section(header: Text("선호 시간대")) {
          Picker("선호 시간", selection: $selectedTimePreference) {
            ForEach(timeOptions, id: \.self) { Text($0) }
          }
          .pickerStyle(.segmented)
        }
        
        Section {
          Button("회원가입") {
//            print("🔵 회원가입 버튼 눌림")
//               showSuccessAlert = true
            handleSignUp()
          }
        }
      }
    }
    .navigationTitle("회원가입")
    .alert("🎉 회원가입 완료!", isPresented: $showSuccessAlert) {
      Button("확인") {
        dismiss()
      }
    } message: {
      Text("이제 로그인 화면으로 돌아갑니다.")
    }
  }
  
  private func handleSignUp() {
    print("🟡 버튼 눌림") // 이게 안 뜨면 버튼 자체가 안 작동함
    let signupData = SignupRequest(email: email, password: password, username: username)
    
    APIService.shared.signup(request: signupData) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let response):
          print("✅ 회원가입 성공: \(response)")
          showSuccessAlert = true // 👉 성공 시 알림 띄우기
        case .failure(let error):
          print("❌ 회원가입 실패: \(error.localizedDescription)")
        }
      }
    }
  }
}
    
    
#Preview {
  SignUpView()
}
