//
//  ImageUploadManager.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/20/25.
//

import Foundation

class ImageUploadManager {
  static let shared = ImageUploadManager()
  
  private init() {}
  
  func uploadImage(imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: "http://your-server-url.com/api/timetable/upload") else {
      completion(.failure(NSError(domain: "잘못된 URL", code: -1)))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    body.append("--\(boundary)\r\n")
    body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n")
    body.append("Content-Type: image/jpeg\r\n\r\n")
    body.append(imageData)
    body.append("\r\n--\(boundary)--\r\n")
    
    URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let data = data,
            let string = String(data: data, encoding: .utf8) else {
        completion(.failure(NSError(domain: "응답 없음", code: -2)))
        return
      }
      
      completion(.success(string))
    }.resume()
  }
}

extension Data {
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}
