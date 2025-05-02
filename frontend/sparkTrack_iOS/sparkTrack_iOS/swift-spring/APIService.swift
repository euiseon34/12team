//
//  APIService.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/29/25.
//

import Foundation

// 서버에 보낼 데이터 모델 (Swift에서 JSON으로 변환됨)
struct EventRequest: Codable {
  let title: String
  let description: String
  let categories: String
  let urgency: Int
  let preference: Int
  let startTime: String
  let endTime: String
  let repeatEvent: Bool
}

class APIService {
  
  static let shared = APIService() // 싱글톤
  
  private init() {}
  
  private let baseURL = "http://localhost:8080" // Spring 서버 주소 (배포 시 바꿔야 함)
  
  // MARK: - Event 생성하기
  func createEvent(event: EventRequest, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: "\(baseURL)/api/events") else {
      completion(.failure(NSError(domain: "잘못된 URL", code: -1)))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      let jsonData = try JSONEncoder().encode(event)
      request.httpBody = jsonData
    } catch {
      completion(.failure(error))
      return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      if let data = data, let responseString = String(data: data, encoding: .utf8) {
        completion(.success(responseString))
      } else {
        completion(.failure(NSError(domain: "응답 데이터 없음", code: -2)))
      }
    }.resume()
  }
}
