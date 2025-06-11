//
//  ConstellationDetailView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/10/25.
//

//
//  ConstellationDetailView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/10/25.
//

import SwiftUI

struct ConstellationDetailView: View {
  let stars: [ConstellationStar]
  let title: String
  @State private var animateGradient = false
  
  var body: some View {
    ZStack { // 🚨 ZStack으로 최상위부터 깔기
      Color.black.opacity(0.95).ignoresSafeArea()
      
      VStack(spacing: 20) {
        Text("✩️ \(title) ✩️")
          .font(.largeTitle)
          .bold()
          .foregroundColor(.white)
          .padding(.top, 20)
        
        ConstellationBoardViewReusable(stars: stars, animateGradient: $animateGradient)
          .frame(width: 300, height: 300)
          .layoutPriority(1)
          .onAppear { animateGradient = true }
          .padding(.top, 20)
        
        Spacer()
      }
    }
  }
}

// ⭐️ 프리뷰
#Preview {
  ConstellationDetailView(
    stars: [
        ConstellationStar(position: CGPoint(x: 50, y: 150), isFilled: true),
        ConstellationStar(position: CGPoint(x: 80, y: 170), isFilled: true),
        ConstellationStar(position: CGPoint(x: 110, y: 170), isFilled: true),
        ConstellationStar(position: CGPoint(x: 140, y: 120), isFilled: false), // 원래 70 → 120
        ConstellationStar(position: CGPoint(x: 180, y: 140), isFilled: false),
        ConstellationStar(position: CGPoint(x: 210, y: 170), isFilled: false),
        ConstellationStar(position: CGPoint(x: 250, y: 170), isFilled: false)
    ],
    title: "북두칠성"
  )
}
