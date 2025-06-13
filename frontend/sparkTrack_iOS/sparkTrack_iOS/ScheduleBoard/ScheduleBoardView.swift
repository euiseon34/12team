//
//  ScheduleBoardView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/30/25.
//

import SwiftUI

struct ScheduleBoardView: View {
  @State private var selectedMode: ScheduleMode = .weekly
  @State private var selectedDate = Date()
  @State private var showingUploadSheet = false
  @State private var showingAIScheduleAlert = false // ✅ AI 버튼 동작 임시 Alert 추가 (테스트용)

  let sampleEntries: [TimetableEntry] = [
    TimetableEntry(date: Date(), startTime: "09:00", endTime: "13:00", subject: "근로"),
    TimetableEntry(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, startTime: "10:00", endTime: "11:00", subject: "문화이론"),
    TimetableEntry(date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, startTime: "13:00", endTime: "14:30", subject: "캐릭터"),
    TimetableEntry(date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!, startTime: "15:00", endTime: "16:30", subject: "문학")
  ]

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      VStack(spacing: 16) {
        HStack {
          Picker("보기 모드", selection: $selectedMode) {
            ForEach(ScheduleMode.allCases, id: \.self) { mode in
              Text(mode.rawValue).tag(mode)
            }
          }
          .pickerStyle(.segmented)

          Spacer()
        }
        .padding(.horizontal)

        Divider()

        if selectedMode == .weekly {
          GridTimeTableView(entries: sampleEntries)
        } else {
          DailyTimeTableView(selectedDate: $selectedDate, entries: sampleEntries)
        }
      }

      // ✅ 우측 하단 버튼들 (AI 버튼 + 업로드 버튼)
      VStack(alignment: .trailing, spacing: 16) {
        // AI 일정 생성 버튼
        Button(action: {
          // TODO: AI 일정 생성 기능 연결
          showingAIScheduleAlert = true
        }) {
          Image(systemName: "sparkles")
            .font(.title2)
            .frame(width: 60, height: 60)
            .background(Color.white)
            .foregroundColor(.purple)
            .clipShape(Circle())
            .shadow(radius: 5)
        }

        // 사진 업로드 버튼
        Button(action: {
          showingUploadSheet = true
        }) {
          Image(systemName: "photo.on.rectangle.angled")
            .font(.title2)
            .frame(width: 60, height: 60)
            .background(Color.white)
            .foregroundColor(.purple)
            .clipShape(Circle())
            .shadow(radius: 5)
        }
      }
      .padding()
      .padding(.bottom, 100)
    }
    .sheet(isPresented: $showingUploadSheet) {
      ImageUploaderView()
    }
    .alert(isPresented: $showingAIScheduleAlert) {
      Alert(
        title: Text("AI 일정 생성"),
        message: Text("AI 일정 생성 기능을 여기에 연결하세요."),
        dismissButton: .default(Text("확인"))
      )
    }
    .navigationTitle("시간표 보기")
    .navigationBarTitleDisplayMode(.inline)
  }
}

enum ScheduleMode: String, CaseIterable {
  case weekly = "주간"
  case daily = "일간"
}

#Preview {
  ScheduleBoardView()
}
