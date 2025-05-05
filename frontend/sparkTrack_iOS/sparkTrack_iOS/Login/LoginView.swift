//
//  LoginView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/2/25.
//

import SwiftUI

struct LoginRequest: Codable {
  let username: String
  let password: String
}

struct LoginResponse: Codable {
  let token: String
}

func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
  guard let url = URL(string: "http://localhost:8080/api/users/login") else {
    completion(.failure(NSError(domain: "잘못된 URL", code: -1)))
    return
  }
  
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  
  let loginData = LoginRequest(username: username, password: password)
  do {
    request.httpBody = try JSONEncoder().encode(loginData)
  } catch {
    completion(.failure(error))
    return
  }
  
  URLSession.shared.dataTask(with: request) { data, response, error in
    if let error = error {
      completion(.failure(error))
      return
    }
    
    guard let data = data else {
      completion(.failure(NSError(domain: "데이터 없음", code: -2)))
      return
    }
    
    do {
      let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
      completion(.success(decoded.token))
    } catch {
      completion(.failure(error))
    }
  }.resume()
}

struct LoginView: View {
  @State private var username = ""
  @State private var password = ""
  @State private var loginStatus = ""
  @State private var isLoggedIn = false
  @State private var token: String? = nil
  
  var body: some View {
    VStack(spacing: 20) {
      Text("로그인")
        .font(.largeTitle)
        .bold()
      
      TextField("아이디", text: $username)
        .textFieldStyle(.roundedBorder)
        .autocapitalization(.none)
        .padding(.horizontal)

      SecureField("비밀번호", text: $password)
        .textFieldStyle(.roundedBorder)
        .padding(.horizontal)
      
      Button("로그인") {
        login(username: username, password: password) { result in
          DispatchQueue.main.async {
            switch result {
            case .success(let token):
              print("✅ 로그인 성공, 토큰: \(token)")
              loginStatus = "로그인 성공!"
              self.token = token
              isLoggedIn = true
              // 예: UserDefaults.standard.set(token, forKey: "authToken")
            case .failure(let error):
              print("❌ 로그인 실패: \(error.localizedDescription)")
              loginStatus = "로그인 실패"
            }
          }
        }
      }
      .buttonStyle(.borderedProminent)
      .padding()

      Text(loginStatus)
        .foregroundColor(.gray)
    }
    .fullScreenCover(isPresented: $isLoggedIn) {
      if let token = token {
        TabBarView() // 필요 시 token: token 전달
      }
    }
<<<<<<< Updated upstream
  }
=======
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
>>>>>>> Stashed changes
}



#Preview {
    LoginView()
}
