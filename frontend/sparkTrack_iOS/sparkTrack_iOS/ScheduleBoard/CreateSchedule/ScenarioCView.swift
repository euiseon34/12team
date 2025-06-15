//
//  ScenarioCView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/15/25.
//

import SwiftUI

struct ScenarioCView: View {
  let scenarioCEntries: [TimetableEntry] = [
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "14:00"), startTime: "14:00", endTime: "14:50", subject: "토익 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "15:00"), startTime: "15:00", endTime: "15:50", subject: "토익 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "20:00"), startTime: "20:00", endTime: "20:50", subject: "컴활 실습", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "21:00"), startTime: "21:00", endTime: "21:50", subject: "컴활 실습", status: "유동"),

    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "09:00"), startTime: "09:00", endTime: "09:50", subject: "병원 진료", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "10:30"), startTime: "10:30", endTime: "11:20", subject: "헬스장", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "14:00"), startTime: "14:00", endTime: "14:50", subject: "개인 프로젝트 정리", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "15:00"), startTime: "15:00", endTime: "15:50", subject: "개인 프로젝트 정리", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "16:00"), startTime: "16:00", endTime: "16:10", subject: "개인 프로젝트 정리", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "14:00"), startTime: "14:00", endTime: "18:00", subject: "알바", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "21:00"), startTime: "21:00", endTime: "21:50", subject: "독서", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "22:00"), startTime: "22:00", endTime: "22:50", subject: "독서", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "14:00"), startTime: "14:00", endTime: "21:00", subject: "친구와 약속", status: "고정"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "10:00"), startTime: "10:00", endTime: "11:30", subject: "헬스장", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "14:00"), startTime: "14:00", endTime: "15:50", subject: "친구와 카페", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "18:00"), startTime: "18:00", endTime: "22:00", subject: "알바", status: "고정"),

    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "10:00"), startTime: "10:00", endTime: "11:00", subject: "헬스장", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "12:30"), startTime: "12:30", endTime: "13:30", subject: "자격증 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "13:30"), startTime: "13:30", endTime: "14:30", subject: "자격증 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "17:00"), startTime: "17:00", endTime: "19:00", subject: "가족 외식", status: "고정")
  ]

  var body: some View {
    EmptyView()
  }
}

#Preview {
    ScenarioCView()
}
