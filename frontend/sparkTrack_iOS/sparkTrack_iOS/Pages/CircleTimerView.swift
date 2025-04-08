//
//  CircleTimerView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct CircleTimerView: View {
  
  var startPercent: CGFloat = 0
  // 끝나는 각도,
  var endPercent: CGFloat = 50
  // 원의 색상
  var color: Color = .red
  // 원의 배경 색상
  var backgroundColor: Color = .black
  
  var body: some View {
    GeometryReader { geometryProxy in
      ZStack(alignment: .center) {
        Circle()
          .foregroundColor(self.color)
        Path { path in
          let size = geometryProxy.size
          let center = CGPoint(x: size.width / 2.0,
                               y: size.height / 2.0)
          let radius = min(size.width, size.height) / 2.0
          path.move(to: center)
          path.addArc(center: center,
                      radius: radius,
                      startAngle: .init(degrees: Double(self.startPercent)),
                      endAngle: .init(degrees: Double(self.endPercent)),
                      clockwise: true)
        }
        .rotation(.init(degrees: 270))
        .foregroundColor(self.backgroundColor)
        .frame(width: geometryProxy.size.width,
               height: geometryProxy.size.height,
               alignment: .center)
      }
    }
  }
}

#Preview {
    CircleTimerView()
}
