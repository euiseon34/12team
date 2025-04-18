//
//  HomeView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct HomeView: View {
  @State private var events: [CalendarEvent] = []
  
  var body: some View {
    
    ScrollView() {
      VStack {
        QuadrantView(tasks: [
          QuadrantTask(title: "과제 제출", isImportant: true, isUrgent: true),
          QuadrantTask(title: "회의 준비", isImportant: true, isUrgent: false),
          QuadrantTask(title: "이메일 확인", isImportant: false, isUrgent: true),
          QuadrantTask(title: "운동하기", isImportant: false, isUrgent: false)
        ])
        .padding(.top, 60)
        
        UrgencyPreferenceMatrixView(tasks: events.map {
          Task(title: $0.title, urgency: $0.urgency, preference: $0.preference)
        })
        .padding(.top, 30)
        
        //        CustomCalenderView(events: $events) // 📌 중요
      }
      
      Rectangle()
        .frame(width: 380, height: 500)
        .foregroundStyle(.gray)
        .opacity(0.2)
        .padding(.top, 10)
      // 투두 뷰 들어갈 예정
      
    }
  }
}


#Preview {
    HomeView()
}
