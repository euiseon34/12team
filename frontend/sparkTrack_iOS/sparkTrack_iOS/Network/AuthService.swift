//
//  AuthService.swift
//  sparkTrack_iOS
//
//  Created by 이지우 on 5/4/25.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct TokenResponse: Codable {
    let token: String
}

class AuthService {
    static var shared = AuthService()
    private init() {}
    
   internal let baseURL = "http://localhost:8080"
    
    func login(email: String, password: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/login") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = LoginRequest(email: email, password: password)
        request.httpBody = try? JSONEncoder().encode(loginData)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("❌ 로그인 실패: \(error?.localizedDescription ?? "")")
                completion(nil)
                return
            }

            let decoded = try? JSONDecoder().decode(TokenResponse.self, from: data)
            if let token = decoded?.token {
                print("✅ 토큰 발급 완료: \(token)")
                UserDefaults.standard.set(token, forKey: "jwtToken")
                completion(token)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
