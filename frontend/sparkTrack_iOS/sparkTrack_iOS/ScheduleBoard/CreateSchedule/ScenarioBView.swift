//
//  ScenarioBView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/15/25.
//

import SwiftUI

struct ScenarioBView: View {
  let scenarioBEntries: [TimetableEntry] = [
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "10:00"), startTime: "10:00", endTime: "10:50", subject: "서양철학 레포트 작성", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "11:00"), startTime: "11:00", endTime: "11:40", subject: "서양철학 레포트 작성", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "13:00"), startTime: "13:00", endTime: "15:00", subject: "팀 프로젝트 회의", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "18:00"), startTime: "18:00", endTime: "19:00", subject: "대학생활과", status: "고정"),

    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "09:30"), startTime: "09:30", endTime: "10:30", subject: "채플", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "11:00"), startTime: "11:00", endTime: "13:00", subject: "필라테스 클래스", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "14:00"), startTime: "14:00", endTime: "14:50", subject: "English 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "15:00"), startTime: "15:00", endTime: "15:50", subject: "English 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "16:00"), startTime: "16:00", endTime: "16:50", subject: "통계학개론 요약 정리", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "18:00"), startTime: "18:00", endTime: "22:00", subject: "알바", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "09:00"), startTime: "09:00", endTime: "12:00", subject: "공업수학1", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "12:00"), startTime: "12:00", endTime: "13:30", subject: "통계학개론", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "14:00"), startTime: "14:00", endTime: "16:00", subject: "서양철학:쟁점과토론", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "16:30"), startTime: "16:30", endTime: "18:30", subject: "고급C프로그래밍", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "20:00"), startTime: "20:00", endTime: "20:50", subject: "공업수학 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "21:00"), startTime: "21:00", endTime: "21:50", subject: "공업수학 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "22:00"), startTime: "22:00", endTime: "22:30", subject: "공업수학 기말 공부", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "12:00"), startTime: "12:00", endTime: "15:00", subject: "공학설계기초", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "15:00"), startTime: "15:00", endTime: "16:30", subject: "English", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "18:00"), startTime: "18:00", endTime: "18:50", subject: "팀플 발표 자료 정리", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "19:00"), startTime: "19:00", endTime: "18:40", subject: "팀플 발표 자료 정리", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "09:30"), startTime: "09:30", endTime: "10:20", subject: "알고리즘 과제 마무리", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "12:00"), startTime: "12:00", endTime: "13:30", subject: "통계학개론", status: "고정"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "16:00"), startTime: "16:00", endTime: "16:50", subject: "C프로그래밍 복습", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "17:00"), startTime: "17:00", endTime: "17:40", subject: "C프로그래밍 복습", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "18:00"), startTime: "18:00", endTime: "22:00", subject: "알바", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "22:30"), startTime: "22:30", endTime: "23:00", subject: "알고리즘 과제 마무리", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "09:00"), startTime: "09:00", endTime: "09:50", subject: "공업수학 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "10:00"), startTime: "10:00", endTime: "10:40", subject: "공업수학 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "14:00"), startTime: "14:00", endTime: "14:50", subject: "통계학개론 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "15:00"), startTime: "15:00", endTime: "15:40", subject: "통계학개론 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "16:00"), startTime: "16:00", endTime: "16:50", subject: "English 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "17:00"), startTime: "17:00", endTime: "17:50", subject: "English 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "20:00"), startTime: "20:00", endTime: "21:00", subject: "고급C 실습", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "토", time: "21:10"), startTime: "21:10", endTime: "22:10", subject: "고급C 실습", status: "유동"),
    
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "09:00"), startTime: "09:00", endTime: "09:50", subject: "공업수학 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "10:00"), startTime: "10:00", endTime: "10:40", subject: "공업수학 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "14:00"), startTime: "14:00", endTime: "14:50", subject: "공업수학 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "15:00"), startTime: "15:00", endTime: "15:40", subject: "공업수학 기말 공부", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "19:00"), startTime: "19:00", endTime: "19:50", subject: "서양철학 보고서 작성", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "20:00"), startTime: "20:00", endTime: "20:50", subject: "서양철학 보고서 작성", status: "유동"),
    TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "일", time: "21:00"), startTime: "21:00", endTime: "21:10", subject: "서양철학 보고서 작성", status: "유동")
  ]

  var body: some View {
    EmptyView()
  }
}

#Preview {
    ScenarioBView()
}
