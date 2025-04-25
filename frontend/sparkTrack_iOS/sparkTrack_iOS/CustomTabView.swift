//
//  CustomTabView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct CustomTabView: View {
//  enum Tab {
//    case evaluation
//    case calender
//    case home
//    case summary
//    case user
//  }
  
  @Binding var selectedTab: Tab
  
  var body: some View {
    ZStack {
      Rectangle()
        .frame(height: 100)
        .foregroundStyle(.white)
      
      VStack(spacing: 0){
        Rectangle()
          .frame(height: 4)
        
        Spacer()
        HStack {
          Spacer()
          Button(action: {selectedTab = .evaluation}){
            ButtonView(
              icon: Image(systemName: "pencil"),
              title: "평가",
              isSelected: selectedTab == .evaluation
            )
          }
          
          Spacer()
          Button(action: {selectedTab = .calendar}){
            ButtonView(
              icon: Image(systemName: "calendar"),
              title: "캘린더",
              isSelected: selectedTab == .calendar
            )
          }
          
          Spacer()
          Button(action: {selectedTab = .home}){
            ButtonView(
              icon: Image(systemName: "house"),
              title: "홈",
              isSelected: selectedTab == .home
            )
          }
          
          Spacer()
          Button(action: {selectedTab = .summary}){
            ButtonView(
              icon: Image(systemName: "trophy"),
              title: "통계",
              isSelected: selectedTab == .summary
            )
          }
          
          Spacer()
          Button(action: {selectedTab = .user}){
            ButtonView(
              icon: Image(systemName: "person"),
              title: "마이",
              isSelected: selectedTab == .user
            )
          }
          
          Spacer()
        }
        .frame(width: 400, height: 55)
        .padding(.vertical, 15)
      }
      .frame(height: 90)
      .edgesIgnoringSafeArea(.bottom)
    }
  }
}

#Preview {
  CustomTabView(selectedTab: .constant(.home))
}
