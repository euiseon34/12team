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
    static let shared = AuthService()
    private init() {}

    internal let baseURL = "http://localhost:8080"

    // MARK: - 로그인
    func login(email: String, password: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/login") else {
            print("❌ [DEBUG] 로그인 URL 생성 실패")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginData = LoginRequest(email: email, password: password)

        do {
            let jsonData = try JSONEncoder().encode(loginData)
            request.httpBody = jsonData

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 [DEBUG] 로그인 요청 데이터: \(jsonString)")
            }
        } catch {
            print("❌ [DEBUG] 로그인 데이터 인코딩 실패: \(error.localizedDescription)")
            completion(nil)
            return
        }

        print("🌍 [DEBUG] 로그인 요청 URL: \(url.absoluteString)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ [DEBUG] 로그인 요청 실패: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❗️ [DEBUG] 로그인 응답 없음")
                completion(nil)
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("📩 [DEBUG] 로그인 응답 JSON: \(jsonString)")
            }

            do {
                let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
                let token = decoded.token
                UserDefaults.standard.set(token, forKey: "jwtToken")
                print("✅ [DEBUG] JWT 토큰 저장 완료: \(token)")
                completion(token)
            } catch {
                print("❌ [DEBUG] 로그인 응답 디코딩 실패: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    // MARK: - 로그아웃
    func logout() {
        UserDefaults.standard.removeObject(forKey: "jwtToken")
        print("🔒 [DEBUG] 로그아웃 완료 - JWT 토큰 삭제됨")
    }

    // MARK: - 로그인 여부 확인
    func isLoggedIn() -> Bool {
        let loggedIn = UserDefaults.standard.string(forKey: "jwtToken") != nil
        print("ℹ️ [DEBUG] 로그인 상태: \(loggedIn ? "✅ 로그인 중" : "❌ 로그아웃됨")")
        return loggedIn
    }
}
