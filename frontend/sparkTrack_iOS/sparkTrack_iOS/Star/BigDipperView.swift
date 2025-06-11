//
//  BigDipperView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/3/25.
//

//
//  BigDipperView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/3/25.
//

import SwiftUI

struct BigDipperView: View {
  @ObservedObject var viewModel: ConstellationViewModel
  @State private var animateGradient = false
  
  var body: some View {
    ConstellationBoardViewReusable(stars: viewModel.stars, animateGradient: $animateGradient)
      .onAppear {
        animateGradient = true
      }
  }
}

#Preview {
  let viewModel = ConstellationViewModel.shared
  viewModel.reset()
  viewModel.addScore(300) // ✅ 3개 별 채우기

  return BigDipperView(viewModel: viewModel)
}
