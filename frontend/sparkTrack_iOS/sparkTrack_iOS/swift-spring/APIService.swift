//
//  APIService.swift
//  sparkTrack_iOS
//
//  Created by 이지우 on 5/4/25.
//

import Foundation

// ✅ 서버에 보낼 Task 데이터 모델
struct EventRequest: Codable {
    let title: String
    let description: String
    let category: String
    let repeatEvent: Bool
    let completed: Bool
    let priority: Int // 여기 바뀜
    let preference: Int
    let startTime: String   // ISO8601 형식 문자열
    let endTime: String     // ISO8601 형식 문자열
}

struct SignupRequest: Codable {
    let email: String
    let password: String
    let username: String
}

// ✅ APIService 싱글톤 클래스
class APIService {
  
  static let shared = APIService()
  private init() {}
  
  let baseURL = "http://localhost:8080"
  
  /// ✅ Task를 Spring 서버에 저장하는 API
  func createTask(task: EventRequest, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: "\(baseURL)/api/tasks") else {
      completion(.failure(NSError(domain: "URL Error", code: -1)))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // JWT 토큰 헤더에 포함
    if let token = UserDefaults.standard.string(forKey: "jwtToken") {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    } else {
      completion(.failure(NSError(domain: "Token Missing", code: -2)))
      return
    }
    
    do {
      request.httpBody = try JSONEncoder().encode(task)
    } catch {
      completion(.failure(error))
      return
    }
    
    URLSession.shared.dataTask(with: request) { data, _, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      if let data = data, let result = String(data: data, encoding: .utf8) {
        completion(.success(result))
      } else {
        completion(.failure(NSError(domain: "No Data", code: -3)))
      }
    }.resume()
  }
  
  // ✅ 회원가입 API
  func signup(request: SignupRequest, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: "\(baseURL)/signup") else {
      completion(.failure(NSError(domain: "Invalid frontendURL", code: -1)))
      return
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      urlRequest.httpBody = try JSONEncoder().encode(request)
    } catch {
      completion(.failure(error))
      return
    }
    
    URLSession.shared.dataTask(with: urlRequest) { data, _, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      if let data = data, let result = String(data: data, encoding: .utf8) {
        completion(.success(result))
      } else {
        completion(.failure(NSError(domain: "Empty response", code: -2)))
      }
    }.resume()
  }
}
