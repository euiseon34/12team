//
//  SummaryView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/6/25.
//

import SwiftUI
import Charts

struct SummaryView: View {
  let allEvents: [CalendarEvent]
  @State private var comparisonDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!

  var body: some View {
    let today = Date()
    let todayEvents = events(on: today)
    let pastEvents = events(on: comparisonDate)

    let todayCompletion = completionRate(for: todayEvents)
    let pastCompletion = completionRate(for: pastEvents)

    let difference = todayCompletion - pastCompletion
    let diffSymbol = difference > 0 ? "▲" : (difference < 0 ? "▼" : "–")

    ScrollView {
      VStack(spacing: 32) {
        Text("📊 Summary")
          .font(.title2.bold())
          .foregroundStyle(Color.white)

        MoonPhaseRingView(progress: Double(todayCompletion) / 100.0)
        
        VStack(spacing: 12) {
          Text("📅 비교 기준 날짜 선택")
            .font(.subheadline)
            .foregroundStyle(Color.white)

          DatePicker("", selection: $comparisonDate, displayedComponents: .date)
            .datePickerStyle(.compact)
            .labelsHidden()

          HStack(spacing: 32) {
            VStack {
              Text("오늘")
                .font(.caption)
                .foregroundStyle(Color.white)
              Text("\(todayCompletion)%")
                .font(.title3)
                .foregroundColor(.blue)
            }

            VStack {
              Text(formattedDate(comparisonDate))
                .font(.caption)
                .foregroundStyle(Color.white)
              Text("\(pastCompletion)%")
                .font(.title3)
                .foregroundColor(.gray)
            }
          }

          HStack(spacing: 4) {
            Text("변화:")
              .font(.caption)
              .foregroundStyle(Color.white)
            Text(diffSymbol)
              .foregroundColor(difference > 0 ? .green : difference < 0 ? .red : .gray)
            Text("\(abs(difference))%")
              .font(.caption.bold())
              .foregroundStyle(Color.white)
          }
        }

        Divider()

        // ⭐️ 피드백 영역 추가
        VStack(alignment: .leading, spacing: 8) {
          Text("📝 피드백")
            .font(.subheadline)
            .foregroundStyle(Color.white)

          ForEach(feedbackTexts, id: \.self) { line in
            Text("• \(line)")
              .font(.footnote)
              .foregroundStyle(Color.white)
          }
        }

        Divider()

        VStack(alignment: .leading, spacing: 8) {
          Text("📈 최근 7일간 평균 달성도")
            .font(.subheadline)
            .foregroundStyle(Color.white)

          Chart(getWeeklyData()) { data in
            BarMark(
              x: .value("날짜", data.date, unit: .day),
              y: .value("달성도", data.progress)
            )
            .foregroundStyle(.orange)
          }
          .chartYScale(domain: 0...100)
          .chartXAxis {
            AxisMarks { value in
              AxisGridLine().foregroundStyle(Color.gray.opacity(0.3))
              AxisTick().foregroundStyle(Color.gray.opacity(0.5))
              AxisValueLabel().foregroundStyle(Color.white)
            }
          }
          .chartYAxis {
            AxisMarks { value in
              AxisGridLine().foregroundStyle(Color.gray.opacity(0.3))
              AxisTick().foregroundStyle(Color.gray.opacity(0.5))
              AxisValueLabel().foregroundStyle(Color.white)
            }
          }
          .frame(height: 180)
        }

        Spacer(minLength: 100)
      }
      .padding()
    }
  }

  private func events(on date: Date) -> [CalendarEvent] {
    let cal = Calendar.current
    return allEvents.filter {
      cal.isDate($0.date, inSameDayAs: date)
    }
  }

  private func completionRate(for events: [CalendarEvent]) -> Int {
    guard !events.isEmpty else { return 0 }
    let total = events.map { $0.completionRate }.reduce(0, +)
    return total / events.count
  }

  private func completionRate(for events: [CalendarEvent], category: String) -> Int {
    let filtered = events.filter { $0.category == category }
    guard !filtered.isEmpty else { return 0 }
    let total = filtered.map { $0.completionRate }.reduce(0, +)
    return total / filtered.count
  }

  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
  }

  private func getWeeklyData() -> [DailyProgress] {
    let cal = Calendar.current
    let now = Date()
    let last7Days = (0..<7).map { cal.date(byAdding: .day, value: -$0, to: now)! }.reversed()

    return last7Days.map { date in
      let events = allEvents.filter { cal.isDate($0.date, inSameDayAs: date) }
      let average = events.isEmpty ? 0 : events.map { $0.completionRate }.reduce(0, +) / events.count
      return DailyProgress(date: date, progress: average)
    }
  }

  // ⭐️ AI 피드백 텍스트 생성
  private var feedbackTexts: [String] {
    let todayEvents = events(on: Date())
    let pastEvents = events(on: comparisonDate)

    let todayCompletion = completionRate(for: todayEvents)
    let pastCompletion = completionRate(for: pastEvents)

    var feedback: [String] = []

    if todayCompletion > pastCompletion {
      feedback.append("전체 달성도가 \(todayCompletion - pastCompletion)% 상승했어요. 멋져요! 🚀")
    } else if todayCompletion < pastCompletion {
      feedback.append("전체 달성도가 \(pastCompletion - todayCompletion)% 감소했어요. 다시 힘내봐요! 🌱")
    } else {
      feedback.append("전체 달성도는 변동이 없어요. 꾸준히 유지 중이에요. ✨")
    }

    let categories = Set(todayEvents.map { $0.category } + pastEvents.map { $0.category })

    let categoryDiffs = categories.map { category -> (String, Int) in
      let todayRate = completionRate(for: todayEvents, category: category)
      let pastRate = completionRate(for: pastEvents, category: category)
      return (category, todayRate - pastRate)
    }

    if let mostChanged = categoryDiffs.max(by: { abs($0.1) < abs($1.1) }) {
      let (category, diff) = mostChanged
      if diff > 0 {
        feedback.append("'\(category)' 카테고리에서 \(diff)% 향상되었어요. 👍")
      } else if diff < 0 {
        feedback.append("'\(category)' 카테고리에서 \(abs(diff))% 감소했어요. 조금 더 집중해볼까요? 💪")
      } else {
        feedback.append("'\(category)' 카테고리는 변화가 없어요. 🎈")
      }
    }

    return feedback
  }
}

struct DailyProgress: Identifiable {
  let id = UUID()
  let date: Date
  let progress: Int
}

struct MoonPhaseRingView: View {
  var progress: Double
  @State private var isGlowing = false
  
  var body: some View {
    ZStack {
      Circle()
        .fill(Color.black)
      
      GeometryReader { geometry in
        let width = geometry.size.width
        Rectangle()
          .fill(Color.yellow)
          .frame(width: width * progress)
          .alignmentGuide(.leading) { _ in 0 }
          .offset(x: 0)
          .animation(.easeInOut(duration: 1.0), value: progress)
      }
      .clipShape(Circle())
      
      Circle()
        .stroke(Color.yellow, lineWidth: 3)
        .shadow(color: Color.yellow.opacity(0.5), radius: isGlowing ? 8 : 3)
        .scaleEffect(isGlowing ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isGlowing)
      
      VStack(spacing: 4) {
        Text("완료율")
          .font(.caption)
          .foregroundColor(.gray)
        Text("\(Int(progress * 100))%")
          .font(.title2)
          .fontWeight(.semibold)
          .foregroundColor(.white)
      }
    }
    .frame(width: 150, height: 150)
    .onAppear {
      isGlowing = true
    }
  }
}

#Preview {
  SummaryView(
    allEvents: [
      CalendarEvent(date: Date(), title: "오늘 할 일", urgency: 3, preference: 4, startTime: Date(), endTime: Date(), isCompleted: true, completionRate: 80, category: "공부"),
      CalendarEvent(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, title: "어제 할 일", urgency: 3, preference: 4, startTime: Date(), endTime: Date(), isCompleted: true, completionRate: 60, category: "공부")
    ]
  )
}
