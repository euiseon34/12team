//
//  CustomCalenderView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/14/25.
//

import SwiftUI

struct CustomCalendarView: View {
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        return formatter
    }()

    var body: some View {
        VStack(spacing: 16) {
            // 월/년 표시
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthYearString(for: currentDate))
                    .font(.headline)
                Spacer()
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)

            // 요일 헤더
            let days = ["일", "월", "화", "수", "목", "금", "토"]
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
            }

            // 날짜 그리드
            let daysInMonth = generateDaysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daysInMonth, id: \.self) { date in
                    Button(action: {
                        selectedDate = date
                    }) {
                        Text("\(calendar.component(.day, from: date))")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedDate == date ? Color.blue.opacity(0.3) : Color.clear)
                            )
                    }
                    .disabled(!calendar.isDate(date, equalTo: currentDate, toGranularity: .month))
                }
            }

            // 선택된 날짜 표시
            if let selected = selectedDate {
                Text("선택한 날짜: \(dateFormatter.string(from: selected))")
                    .padding()
            }
        }
        .padding()
    }

    // 월 변경 함수
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
            selectedDate = nil
        }
    }

    // 월/년 문자열 생성
    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }

    // 날짜 배열 생성
    private func generateDaysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }

        var days: [Date] = []
        let paddingDays = firstWeekday - calendar.firstWeekday
        for i in 0..<(paddingDays < 0 ? 7 + paddingDays : paddingDays) {
            days.append(calendar.date(byAdding: .day, value: -i - 1, to: monthInterval.start)!)
        }
        days.reverse()

        for offset in 0..<calendar.dateComponents([.day], from: monthInterval.start, to: monthInterval.end).day! {
            if let date = calendar.date(byAdding: .day, value: offset, to: monthInterval.start) {
                days.append(date)
            }
        }
        return days
    }
}

#Preview {
    CustomCalendarView()
}
