//
//  RankService.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/30/25.
//

import SwiftUI
import Foundation

class RankService {
    static let shared = RankService()
    private init() {}

    private let baseURL = "http://localhost:8080"

    func fetchRankList(completion: @escaping (Result<[RankUser], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/rank/list") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = UserDefaults.standard.string(forKey: "jwtToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -2)))
                return
            }

            do {
                let users = try JSONDecoder().decode([RankUser].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
