//
//  ConstellationDexView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 6/10/25.
//

import SwiftUI

struct ConstellationDexView: View {
  let constellations: [ConstellationEntry] = [
    ConstellationEntry(
      name: "북두칠성",
      isCompleted: true,
      stars: [
        ConstellationStar(position: CGPoint(x: 50, y: 100), isFilled: true),
        ConstellationStar(position: CGPoint(x: 80, y: 120), isFilled: true),
        ConstellationStar(position: CGPoint(x: 110, y: 120), isFilled: true),
        ConstellationStar(position: CGPoint(x: 140, y: 70), isFilled: true),
        ConstellationStar(position: CGPoint(x: 180, y: 90), isFilled: true),
        ConstellationStar(position: CGPoint(x: 210, y: 120), isFilled: true),
        ConstellationStar(position: CGPoint(x: 250, y: 120), isFilled: true)
      ]
    ),
    ConstellationEntry(
      name: "오리온자리",
      isCompleted: false,
      stars: [
        ConstellationStar(position: CGPoint(x: 50, y: 100), isFilled: false),
        ConstellationStar(position: CGPoint(x: 80, y: 150), isFilled: false),
        ConstellationStar(position: CGPoint(x: 110, y: 120), isFilled: false),
        ConstellationStar(position: CGPoint(x: 150, y: 170), isFilled: false)
      ]
    )
  ]

  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  @State private var selectedConstellation: ConstellationEntry? = nil
  @State private var showConstellationDetail = false
  @State private var showLockedAlert = false

  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(constellations) { constellation in
            VStack {
              ZStack {
                Circle()
                  .fill(constellation.isCompleted ? Color.yellow : Color.gray.opacity(0.4))
                  .frame(width: 80, height: 80)
                  .overlay(
                    Circle()
                      .stroke(Color.white.opacity(0.8), lineWidth: 2)
                  )
                  .shadow(color: constellation.isCompleted ? .yellow : .clear, radius: 10)

                Image(systemName: constellation.isCompleted ? "star.fill" : "lock.fill")
                  .font(.title)
                  .foregroundColor(.white)
              }

              Text(constellation.name)
                .font(.caption)
                .foregroundColor(.white)
            }
            .onTapGesture {
              if constellation.isCompleted {
                selectedConstellation = constellation
                showConstellationDetail = true
              } else {
                showLockedAlert = true
              }
            }
          }
        }
        .padding()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.black.opacity(0.95).ignoresSafeArea())
      .navigationTitle("✩️ 빛자리 도가림")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("닫기") {}
        }
      }
      .sheet(isPresented: $showConstellationDetail) {
        if let selected = selectedConstellation {
          VStack(spacing: 20) {
            Text("✩️ \(selected.name) ✩️")
              .font(.largeTitle)
              .bold()
              .padding(.top, 20)

            ConstellationDetailView(stars: selected.stars, title: selected.name)

            Spacer()

            Button(action: {
              showConstellationDetail = false
            }) {
              Text("닫기")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 5)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.black.opacity(0.95).ignoresSafeArea())
        }
      }
      .alert(isPresented: $showLockedAlert) {
        Alert(
          title: Text("자금 변자리"),
          message: Text("아직 완성하지 않은 변자리입니다."),
          dismissButton: .default(Text("확인"))
        )
      }
    }
  }
}

#Preview {
  ConstellationDexView()
}
