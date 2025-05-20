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
  
  var body: some View {
    VStack(spacing: 20) {
      Text("시간표 이미지 업로드")
        .font(.title2)
        .bold()
      
      PhotosPicker(
        selection: $selectedItem,
        matching: .images,
        photoLibrary: .shared()) {
          Text("갤러리에서 시간표 선택")
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
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
        case .success(let response):
          self.uploadMessage = "✅ 서버 응답: \(response)"
        case .failure(let error):
          self.uploadMessage = "❌ 업로드 실패: \(error.localizedDescription)"
        }
      }
    }
  }
}

#Preview {
  ImageUploaderView()
}
