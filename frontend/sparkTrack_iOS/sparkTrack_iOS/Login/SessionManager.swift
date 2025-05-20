//
//  SessionManager.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/20/25.
//

import Foundation

class SessionManager {
  static let shared = SessionManager()
  
  private let authTokenKey = "authToken"
  
  private init() {}
  
  // 저장
  func saveAuthToken(_ token: String) {
    UserDefaults.standard.set(token, forKey: authTokenKey)
  }
  
  // 불러오기
  func getAuthToken() -> String? {
    return UserDefaults.standard.string(forKey: authTokenKey)
  }
  
  // 삭제 (로그아웃)
  func clearAuthToken() {
    UserDefaults.standard.removeObject(forKey: authTokenKey)
  }
  
  // 로그인 상태 여부
  var isLoggedIn: Bool {
    return getAuthToken() != nil
  }
}
