//
//  CustomCalenderView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/14/25.
//

import SwiftUI

struct CalendarEvent: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
}

struct CustomCalenderView: View {
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil
    @State private var showEventForm = false
    @State private var events: [CalendarEvent] = []

    private let daySymbols = Calendar.current.shortWeekdaySymbols

    private var daysInMonth: [Date?] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: currentDate),
              let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate)) else {
            return []
        }

        let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth)

        var dates: [Date?] = Array(repeating: nil, count: weekday - 1)
        for day in range {
            if let date = Calendar.current.date(bySetting: .day, value: day, of: currentDate) {
                dates.append(date)
            }
        }
        return dates
    }

    private var eventsForSelectedDate: [CalendarEvent] {
        guard let selectedDate else { return [] }
        return events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var body: some View {
        VStack {
            // 상단 월 이동
            HStack {
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                }

                Spacer()

                Text(monthYearString(from: currentDate))
                    .font(.title2)

                Spacer()

                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)

            // 요일 헤더
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daySymbols, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)

            // 날짜 뷰
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daysInMonth.indices, id: \.self) { index in
                    if let date = daysInMonth[index] {
                        Button(action: {
                            selectedDate = date
                        }) {
                            ZStack(alignment: .topTrailing) {
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(Calendar.current.isDate(date, inSameDayAs: selectedDate ?? Date()) ? Color.blue.opacity(0.2) : Color.clear)
                                    .clipShape(Circle())

                                if events.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 6, height: 6)
                                        .offset(x: 6, y: 2)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Color.clear.frame(height: 44)
                    }
                }
            }
            .padding(.horizontal)

            // 선택된 날짜의 일정 목록 + 추가 버튼
            if let selectedDate {
                Divider()
                VStack(alignment: .leading) {
                    Text("📅 \(selectedDate.formatted(date: .abbreviated, time: .omitted)) 일정")
                        .font(.headline)
                        .padding(.bottom, 4)

                    if eventsForSelectedDate.isEmpty {
                        Text("등록된 일정이 없습니다.")
                            .foregroundStyle(.gray)
                            .padding(.bottom, 4)
                    } else {
                        ForEach(eventsForSelectedDate) { event in
                            HStack {
                                Text("• \(event.title)")
                                Spacer()
                                Button(role: .destructive) {
                                    events.removeAll { $0.id == event.id }
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }

                    Button {
                        showEventForm = true
                    } label: {
                        Label("일정 추가", systemImage: "plus.circle")
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showEventForm) {
            if let selectedDate {
                EventFormView(date: selectedDate) { title in
                    events.append(CalendarEvent(date: selectedDate, title: title))
                }
            }
        }
    }

    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }
}

#Preview {
    CustomCalenderView()
}
