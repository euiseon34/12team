//
//  CelebrationView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/3/25.
//

import SwiftUI

struct CelebrationView: View {
  @Binding var isVisible: Bool
  @State private var animate = false

  var body: some View {
    ZStack {
      if isVisible {
        Color.black.opacity(0.5)
          .ignoresSafeArea()

        VStack(spacing: 20) {
          Image(systemName: "sparkles")
            .resizable()
            .frame(width: 80, height: 80)
            .foregroundColor(.yellow)
            .scaleEffect(animate ? 1.5 : 0.8)
            .opacity(animate ? 1 : 0.2)
            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animate)

          Text("🎉 별자리가 완성되었어요!")
            .font(.title3)
            .bold()
            .foregroundColor(.white)
        }
        .onAppear {
          animate = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isVisible = false
            animate = false
          }
        }
      }
    }
  }
}

#Preview {
  StatefulPreviewWrapper(true) { value in
    CelebrationView(isVisible: value)
  }
}
