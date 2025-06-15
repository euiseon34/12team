//
//  ScenarioAView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/15/25.
//

import SwiftUI

struct ScenarioAView: View {
  let exampleSchedule: [TimetableEntry]

  init() {
    self.exampleSchedule = [
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "09:00"), startTime: "09:00", endTime: "10:30", subject: "문화이론과 대중문화", status: "고정"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "13:00"), startTime: "13:00", endTime: "14:30", subject: "캐릭터 유형론", status: "고정"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "월", time: "15:00"), startTime: "15:00", endTime: "16:30", subject: "문학의 이해", status: "고정"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "화", time: "10:00"), startTime: "10:00", endTime: "11:00", subject: "자기개발활동", status: "유동"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "09:00"), startTime: "09:00", endTime: "10:30", subject: "문화이론과 대중문화", status: "고정"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "13:00"), startTime: "13:00", endTime: "14:30", subject: "캐릭터 유형론", status: "고정"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "15:00"), startTime: "15:00", endTime: "16:30", subject: "문학의 이해", status: "고정"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "수", time: "18:00"), startTime: "18:00", endTime: "19:00", subject: "러닝센터", status: "유동"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "09:00"), startTime: "09:00", endTime: "10:30", subject: "문화이론과 대중문화", status: "고정"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "13:00"), startTime: "13:00", endTime: "14:30", subject: "캐릭터 유형론", status: "고정"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "15:00"), startTime: "15:00", endTime: "16:30", subject: "문학의 이해", status: "고정"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "목", time: "19:00"), startTime: "19:00", endTime: "20:00", subject: "러닝센터", status: "유동"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "09:00"), startTime: "09:00", endTime: "13:00", subject: "근로", status: "고정"),
      TimetableEntry(date: ScenarioAView.dateFromDayAndTime(day: "금", time: "14:00"), startTime: "14:00", endTime: "16:00", subject: "러닝센터", status: "유동")
    ]
  }

  var body: some View {
    GridTimeTableView(entries: exampleSchedule)
      .navigationTitle("시나리오 A")
  }

  static func dateFromDayAndTime(day: String, time: String) -> Date {
    let calendar = Calendar.current
    let weekdaySymbols = ["일": 1, "월": 2, "화": 3, "수": 4, "목": 5, "금": 6, "토": 7]
    var components = DateComponents()

    let today = Date()
    let todayWeekday = calendar.component(.weekday, from: today)
    let targetWeekday = weekdaySymbols[day] ?? 2

    let daysDiff = targetWeekday - todayWeekday
    let targetDate = calendar.date(byAdding: .day, value: daysDiff, to: today) ?? today

    let timeParts = time.split(separator: ":").compactMap { Int($0) }
    components.hour = timeParts[0]
    components.minute = timeParts[1]

    return calendar.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: 0, of: targetDate) ?? targetDate
  }
}

#Preview {
  ScenarioAView()
}
