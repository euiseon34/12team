//
//  HomeView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    
    ScrollView() {
      VStack {
        Rectangle()
          .frame(width: 380, height: 380)
          .foregroundStyle(.gray)
          .opacity(0.5)
          .padding(.top, 80)
        // 사분면 뷰 들어갈 예정
        
        Rectangle()
          .frame(width: 380, height: 500)
          .foregroundStyle(.gray)
          .opacity(0.2)
          .padding(.top, 30)
        // 투두 뷰 들어갈 예정
        
      }
    }
  }
}

#Preview {
    HomeView()
}
