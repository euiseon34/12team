//
//  ButtonView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct ButtonView: View {
  let icon: Image
  var title: String
  var isSelected: Bool
  
    var body: some View {
      VStack {
        icon
          .resizable()
          .scaledToFill()
          .frame(width: 30, height: 30)
          .foregroundStyle(isSelected ? Color.yellow : Color.white)
//          .padding(.bottom, 5)
        Text(title)
          .font(.body)
          .foregroundStyle(isSelected ? Color.yellow : Color.white)
          .padding(.bottom, 22)
      }
    }
}

#Preview {
  ButtonView(
    icon: Image(systemName: "house"),
    title: "홈",
    isSelected: true)
}
