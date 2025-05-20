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
    
    @Environment(\.dismiss) private var dismiss  // 이전 화면으로 돌아가기

    let timeOptions = ["아침", "점심", "저녁"]

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
        }
        .navigationTitle("회원가입")
    }

    private func handleSignUp() {
        let signupData = SignupRequest(email: email, password: password, username: username)

        APIService.shared.signup(request: signupData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ 회원가입 성공: \(response)")
                    dismiss()  // 이전 화면인 로그인 화면으로 돌아감
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
