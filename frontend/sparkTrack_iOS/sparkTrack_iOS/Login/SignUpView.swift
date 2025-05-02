//
//  SignUpView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/2/25.
//

import SwiftUI

struct SignUpRequest: Codable {
  let username: String
  let password: String
  let email: String
  let timePreference: String
}

struct SignUpView: View {
  @State private var username: String = ""
  @State private var password: String = ""
  @State private var email: String = ""
  @State private var selectedTimePreference: String = "아침"
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack(spacing: 20) {
      Text("회원가입")
        .font(.title)
        .fontWeight(.bold)
      
      TextField("아이디", text: $username)
        .textFieldStyle(RoundedBorderTextFieldStyle())

      SecureField("비밀번호", text: $password)
        .textFieldStyle(RoundedBorderTextFieldStyle())

      TextField("이메일", text: $email)
        .textFieldStyle(RoundedBorderTextFieldStyle())

      Picker("선호 시간대", selection: $selectedTimePreference) {
        ForEach(["아침", "점심", "저녁"], id: \.self) { time in
          Text(time)
        }
      }
      .pickerStyle(.segmented)

      Button("회원가입") {
        sendSignUpData()
        dismiss()  // 회원가입 후 로그인 화면으로
      }
    }
    .padding()
  }

  func sendSignUpData() {
    let url = URL(string: "http://localhost:8080/api/users/signup")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let signUpData = SignUpRequest(
      username: username,
      password: password,
      email: email,
      timePreference: selectedTimePreference
    )

    do {
      let jsonData = try JSONEncoder().encode(signUpData)
      request.httpBody = jsonData
    } catch {
      print("❌ 인코딩 오류: \(error)")
      return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("❌ 요청 실패: \(error.localizedDescription)")
        return
      }
      if let data = data {
        print("✅ 응답 수신: \(String(data: data, encoding: .utf8) ?? "")")
      }
    }.resume()
  }
}



#Preview {
  SignUpView()
}
