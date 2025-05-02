//
//  UserModel.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/2/25.
//

import SwiftUI

struct User: Codable {
  var username: String
  var password: String
  var email: String
  var prefersBreakfast: Bool
  var prefersLunch: Bool
  var prefersDinner: Bool
}
