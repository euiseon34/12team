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
  @State private var showingAIScheduleSheet = false
  @State private var showingLoadingView = false
  @State private var showingResultView = false
  @State private var generatedEntries: [TimetableEntry]? = nil
  @State private var isGeneratingSchedule = false

  let sampleEntries: [TimetableEntry] = [
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "18:00"), startTime: "18:00", endTime: "19:00", subject: "대학생활과", status: "고정"),

    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "10:30"), startTime: "09:30", endTime: "10:30", subject: "채플", status: "고정"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "09:00"), startTime: "09:00", endTime: "12:00", subject: "공업수학1", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "12:00"), startTime: "12:00", endTime: "13:30", subject: "통계학개론", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "14:00"), startTime: "14:00", endTime: "16:00", subject: "서양철학:쟁점과토론", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "16:30"), startTime: "16:30", endTime: "18:30", subject: "고급C프로그래밍", status: "고정"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "12:00"), startTime: "12:00", endTime: "15:00", subject: "공학설계기초", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "15:00"), startTime: "15:00", endTime: "16:30", subject: "English", status: "고정"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "12:00"), startTime: "12:00", endTime: "13:30", subject: "통계학개론", status: "고정")
  ]
  
  let scenarioAEntries: [TimetableEntry] = [
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "18:00"), startTime: "18:00", endTime: "19:00", subject: "대학생활과", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "13:00"), startTime: "13:00", endTime: "13:50", subject: "과제", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "14:00"), startTime: "14:00", endTime: "14:40", subject: "과제", status: "유동"),

    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "09:30"), startTime: "09:30", endTime: "10:30", subject: "채플", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "11:00"), startTime: "11:00", endTime: "13:00", subject: "필라테스 클래스", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "18:00"), startTime: "18:00", endTime: "22:00", subject: "알바", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "09:00"), startTime: "09:00", endTime: "12:00", subject: "공업수학1", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "12:00"), startTime: "12:00", endTime: "13:30", subject: "통계학개론", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "14:00"), startTime: "14:00", endTime: "16:00", subject: "서양철학:쟁점과토론", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "16:30"), startTime: "16:30", endTime: "18:30", subject: "고급C프로그래밍", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "20:00"), startTime: "20:00", endTime: "20:40", subject: "고전독서 읽기", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "20:50"), startTime: "20:50", endTime: "21:30", subject: "고전독서 읽기", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "12:00"), startTime: "12:00", endTime: "15:00", subject: "공학설계기초", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "15:00"), startTime: "15:00", endTime: "16:30", subject: "English", status: "고정"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "12:00"), startTime: "12:00", endTime: "13:30", subject: "통계학개론", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "14:00"), startTime: "14:00", endTime: "14:50", subject: "기초 통계 과제", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "15:00"), startTime: "15:00", endTime: "15:50", subject: "기초 통계 과제", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "16:00"), startTime: "16:00", endTime: "16:10", subject: "기초 통계 과제", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "18:00"), startTime: "18:00", endTime: "22:00", subject: "알바", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "15:00"), startTime: "15:00", endTime: "22:00", subject: "친구와 약속", status: "유동")
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

        if isGeneratingSchedule {
          VStack {
            Spacer()
            ProgressView("AI 일정 생성 중...")
              .progressViewStyle(CircularProgressViewStyle(tint: .purple))
              .foregroundColor(.white)
            Spacer()
          }
        } else {
          if let entries = generatedEntries {
            if selectedMode == .weekly {
              GridTimeTableView(entries: entries)
            } else {
              DailyTimeTableView(selectedDate: $selectedDate, entries: entries)
            }
          } else {
            if selectedMode == .weekly {
              GridTimeTableView(entries: sampleEntries)
            } else {
              DailyTimeTableView(selectedDate: $selectedDate, entries: sampleEntries)
            }
          }
        }
      }

      // 우측 하단 버튼들
      VStack(alignment: .trailing, spacing: 16) {
        Button(action: {
          showingAIScheduleSheet = true
        }) {
          Image(systemName: "sparkles")
            .font(.title2)
            .frame(width: 60, height: 60)
            .background(Color.white)
            .foregroundColor(.purple)
            .clipShape(Circle())
            .shadow(radius: 5)
        }

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
    .sheet(isPresented: $showingAIScheduleSheet) {
      AIScheduleInputView { startDate, endDate, midterm, final in
        showingAIScheduleSheet = false
        showingLoadingView = true
        isGeneratingSchedule = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
          generatedEntries = scenarioAEntries
          isGeneratingSchedule = false
          showingLoadingView = false
          showingResultView = true
        }
      }
    }
    .fullScreenCover(isPresented: $showingLoadingView) {
      VStack {
        ProgressView("AI 일정 생성 중입니다...")
          .progressViewStyle(CircularProgressViewStyle())
          .padding()
        Spacer()
      }
    }
    .fullScreenCover(isPresented: $showingResultView) {
      VStack(spacing: 24) {
        Text("✅ AI 일정 생성 완료!")
          .font(.title2.bold())
          .padding()

        Button("확인") {
          showingResultView = false
        }
        .padding()
        .background(Color.purple)
        .foregroundColor(.white)
        .clipShape(Capsule())
      }
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
