//
//  CalenderView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
      VStack() {
        CustomCalenderView()
          .padding(.top, 80)
        
        Spacer()
      }
    }
}

#Preview {
    CalendarView()
}
