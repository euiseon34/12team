//
//  SummaryView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI

import SwiftUI

struct SummaryView: View {
  let allEvents: [CalendarEvent]
  @State private var comparisonDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!

  var body: some View {
    let now = Date()
    let todayEvents = events(on: now)
    let pastEvents = events(on: comparisonDate)

    let todayRate = completionRate(for: todayEvents)
    let pastRate = completionRate(for: pastEvents)
    let diff = todayRate - pastRate
    let diffSymbol = diff > 0 ? "▲" : (diff < 0 ? "▼" : "–")

    ScrollView {
      VStack(spacing: 24) {
        Text("📊 To-Do 달성률 비교")
          .font(.title2)
          .bold()

        DatePicker("비교 기준 날짜", selection: $comparisonDate, displayedComponents: .date)
          .datePickerStyle(.compact)
          .padding(.horizontal)

        HStack {
          VStack {
            Text("오늘")
              .font(.headline)
            Text(String(format: "%.0f%%", todayRate * 100))
              .font(.largeTitle)
              .foregroundColor(.blue)
          }
          Spacer()
          VStack {
            Text(formattedDate(comparisonDate))
              .font(.headline)
            Text(String(format: "%.0f%%", pastRate * 100))
              .font(.largeTitle)
              .foregroundColor(.gray)
          }
        }
        .padding(.horizontal)

        HStack(spacing: 6) {
          Text("변화:")
          Text(diffSymbol)
            .foregroundColor(diff > 0 ? .green : diff < 0 ? .red : .gray)
          Text(String(format: "%.0f%%", abs(diff * 100)))
            .bold()
        }

        ProgressView(value: todayRate)
          .progressViewStyle(.linear)
          .padding(.horizontal)

        // 🔥 최근 7일 그래프
        VStack(alignment: .leading, spacing: 8) {
          Text("📅 최근 7일간 달성률")
            .font(.headline)
            .padding(.leading)

          ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 12) {
              ForEach(last7Days(), id: \.self) { date in
                let dailyEvents = events(on: date)
                let rate = completionRate(for: dailyEvents)

                VStack {
                  Text(String(format: "%.0f%%", rate * 100))
                    .font(.caption)
                    .foregroundColor(.gray)

                  Rectangle()
                    .fill(rateColor(rate))
                    .frame(width: 20, height: CGFloat(rate * 100))
                    .cornerRadius(4)

                  Text(shortDate(date))
                    .font(.caption2)
                    .rotationEffect(.degrees(-30))
                    .frame(width: 40)
                    .padding(.top)
                }
              }
            }
            .padding(.horizontal)
            .frame(height: 200)
          }
        }
      }
      .padding(.top, 70)
    }
  }

  // MARK: - Helpers

  private func events(on date: Date) -> [CalendarEvent] {
    let cal = Calendar.current
    return allEvents.filter {
      cal.isDate($0.date, inSameDayAs: date)
    }
  }

  private func completionRate(for events: [CalendarEvent]) -> Double {
    guard !events.isEmpty else { return 0 }
    let done = events.filter { $0.isCompleted }.count
    return Double(done) / Double(events.count)
  }

  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
  }

  private func shortDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd"
    return formatter.string(from: date)
  }

  private func last7Days() -> [Date] {
    let calendar = Calendar.current
    return (0..<7).map { offset in
      calendar.date(byAdding: .day, value: -offset, to: Date())!
    }.reversed()
  }

  private func rateColor(_ rate: Double) -> Color {
    if rate >= 0.8 {
      return .green
    } else if rate >= 0.4 {
      return .orange
    } else {
      return .red
    }
  }
}


#Preview {
  SummaryView(
    allEvents: [
      CalendarEvent(
        date: Date(),
        title: "오늘 할 일1",
        urgency: 3,
        preference: 4,
        startTime: Date(),
        endTime: Calendar.current.date(byAdding: .hour, value: 1, to: Date()),
        isCompleted: true
      ),
      CalendarEvent(
        date: Date(),
        title: "오늘 할 일2",
        urgency: 2,
        preference: 3,
        startTime: Date(),
        endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
        isCompleted: false
      ),
      CalendarEvent(
        date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
        title: "예전 할 일1",
        urgency: 3,
        preference: 2,
        startTime: Date(),
        endTime: Calendar.current.date(byAdding: .hour, value: 1, to: Date()),
        isCompleted: true
      ),
      CalendarEvent(
        date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
        title: "예전 할 일2",
        urgency: 1,
        preference: 1,
        startTime: Date(),
        endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
        isCompleted: true
      )
    ]
  )
}
