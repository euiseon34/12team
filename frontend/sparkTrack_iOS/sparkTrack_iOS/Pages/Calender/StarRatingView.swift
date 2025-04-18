//
//  StarRatingView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/18/25.
//

import SwiftUI

struct StarRatingView: View {
  @Binding var rating: Int
  private let maxRating = 5
  
  var body: some View {
    HStack {
      ForEach(1...maxRating, id: \.self) { index in
        Image(systemName: index <= rating ? "star.fill" : "star")
          .foregroundColor(.yellow)
          .onTapGesture {
            rating = index
          }
      }
    }
    .font(.title3)
  }
}

#Preview {
  StarRatingView(rating: .constant(3))
}
