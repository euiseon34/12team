//
//  ImageUploaderView.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 5/20/25.
//

import SwiftUI
import PhotosUI

struct ImageUploaderView: View {
  @State private var selectedItem: PhotosPickerItem?
  @State private var selectedImage: UIImage?
  @State private var isUploading = false
  @State private var uploadMessage: String?
  
  @State private var entries: [TimetableEntry] = [] // 👈 시간표 저장용
  
  var body: some View {
    VStack(spacing: 20) {
      Text("시간표 이미지 업로드")
        .font(.title2)
        .bold()
      
      PhotosPicker(
        selection: $selectedItem,
        matching: .images,
        photoLibrary: .shared()
      ) {
        Text("갤러리에서 시간표 선택")
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
      .onTapGesture {
        checkPhotoLibraryAuthorization { granted in
          if !granted {
            uploadMessage = "⚠️ 사진 접근 권한이 필요합니다.\n설정에서 권한을 허용해주세요."
          }
        }
      }
      .onChange(of: selectedItem) { newItem in
        Task {
          guard let item = newItem else { return }
          do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
              self.selectedImage = uiImage
              uploadImage(data: data)
            }
          } catch {
            uploadMessage = "이미지 불러오기 실패: \(error.localizedDescription)"
          }
        }
      }
      
      if let selectedImage = selectedImage {
        Image(uiImage: selectedImage)
          .resizable()
          .scaledToFit()
          .frame(height: 200)
      }
      
      if isUploading {
        ProgressView("업로드 중...")
      }
      
      if let uploadMessage = uploadMessage {
        Text(uploadMessage)
          .foregroundColor(.gray)
          .multilineTextAlignment(.center)
          .padding()
      }
      
      if !entries.isEmpty {
        Divider()
        ProcessedTimetableView(entries: entries) // 👈 시간표 UI 렌더링
      }
    }
    .padding()
  }
  
  private func uploadImage(data: Data) {
    isUploading = true
    uploadMessage = nil
    
    ImageUploadManager.shared.uploadImage(imageData: data) { result in
      DispatchQueue.main.async {
        self.isUploading = false
        switch result {
        case .success(let responseData):
          do {
            let decoded = try JSONDecoder().decode(TimetableResponse.self, from: responseData.data(using: .utf8)!)
            self.entries = decoded.data // 👈 JSON → State로 저장
            self.uploadMessage = "✅ 시간표 분석 완료!"
          } catch {
            self.uploadMessage = "❌ JSON 디코딩 실패: \(error.localizedDescription)"
          }
        case .failure(let error):
          self.uploadMessage = "❌ 업로드 실패: \(error.localizedDescription)"
        }
      }
    }
  }
}

import Photos

func checkPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    switch status {
    case .authorized, .limited:
        completion(true)
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
            DispatchQueue.main.async {
                completion(newStatus == .authorized || newStatus == .limited)
            }
        }
    default:
        completion(false)
    }
}

#Preview {
  ImageUploaderView()
}
