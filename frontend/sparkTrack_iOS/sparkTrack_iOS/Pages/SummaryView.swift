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

          DatePicker("", selection: $comparisonDate, displayedComponents: .date)
            .datePickerStyle(.compact)
            .labelsHidden()

          HStack(spacing: 32) {
            VStack {
              Text("오늘")
                .font(.caption)
              Text("\(todayCompletion)%")
                .font(.title3)
                .foregroundColor(.blue)
            }

            VStack {
              Text(formattedDate(comparisonDate))
                .font(.caption)
              Text("\(pastCompletion)%")
                .font(.title3)
                .foregroundColor(.gray)
            }
          }

          HStack(spacing: 4) {
            Text("변화:")
              .font(.caption)
            Text(diffSymbol)
              .foregroundColor(difference > 0 ? .green : difference < 0 ? .red : .gray)
            Text("\(abs(difference))%")
              .font(.caption.bold())
          }
        }

        Divider()

        VStack(alignment: .leading, spacing: 8) {
          Text("📈 최근 7일간 평균 달성도")
            .font(.subheadline)

          Chart(getWeeklyData()) { data in
            BarMark(
              x: .value("날짜", data.date, unit: .day),
              y: .value("달성도", data.progress)
            )
            .foregroundStyle(.orange)
          }
          .chartYScale(domain: 0...100)
          .frame(height: 180)
        }

        Spacer(minLength: 40) // 스크롤 하단 여유 공간
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
}

struct DailyProgress: Identifiable {
  let id = UUID()
  let date: Date
  let progress: Int
}

struct MoonPhaseRingView: View {
  var progress: Double // 0.0 ~ 1.0 (달 위상)
  @State private var isGlowing = false
  
  var body: some View {
    ZStack {
      // 🌑 전체 달 (검정색 배경)
      Circle()
        .fill(Color.black)
      
      // 🌕 밝아지는 노란색 영역 (왼쪽 → 오른쪽으로 차오름)
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
      
      // 🌙 외곽선
      Circle()
        .stroke(Color.yellow, lineWidth: 3)
        .shadow(color: Color.yellow.opacity(0.5), radius: isGlowing ? 8 : 3)
        .scaleEffect(isGlowing ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isGlowing)
      
      // 텍스트 중앙
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

//struct RingChartView: View {
//  var progress: Double
//  @State private var isGlowing = false
//
//  var body: some View {
//    ZStack {
//      Circle()
//        .stroke(Color.gray.opacity(0.15), lineWidth: 10)
//
//      Circle()
//        .trim(from: 0, to: progress)
//        .stroke(
//          AngularGradient(
//            gradient: Gradient(colors: [
//              Color.yellow,
//              Color(hue: 0.12, saturation: 1.0, brightness: 1.0),
//              Color(hue: 0.13, saturation: 0.8, brightness: 0.95)
//            ]),
//            center: .center
//          ),
//          style: StrokeStyle(lineWidth: 10, lineCap: .round)
//        )
//        .rotationEffect(.degrees(-90))
//        .shadow(color: Color.yellow.opacity(0.6), radius: 10)
//        .shadow(color: Color.white.opacity(0.3), radius: 4)
//        .scaleEffect(isGlowing ? 1.04 : 1.0)
//        .opacity(isGlowing ? 1.0 : 0.9)
//        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isGlowing)
//        .onAppear {
//          isGlowing = true
//        }
//
//      VStack(spacing: 4) {
//        Text("완료율")
//          .font(.caption)
//          .foregroundColor(.gray)
//        Text("\(Int(progress * 100))%")
//          .font(.title2)
//          .fontWeight(.semibold)
//          .foregroundColor(.primary)
//      }
//    }
//    .frame(width: 150, height: 150)
//    .padding()
//  }
//}

#Preview {
  SummaryView(
    allEvents: [
      CalendarEvent(date: Date(), title: "오늘 할 일", urgency: 3, preference: 4, startTime: Date(), endTime: Date(), isCompleted: true, completionRate: 80, category: "공부"),
      CalendarEvent(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, title: "어제 할 일", urgency: 3, preference: 4, startTime: Date(), endTime: Date(), isCompleted: true, completionRate: 60, category: "공부")
    ]
  )
}
