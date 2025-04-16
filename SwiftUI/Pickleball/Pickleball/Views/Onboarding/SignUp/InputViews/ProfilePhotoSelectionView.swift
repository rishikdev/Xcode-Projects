//
//  ProfilePhotoSelectionView.swift
//  Pickleball
//
//  Created by Rishik Dev on 18/11/24.
//

import SwiftUI
import PhotosUI

struct ProfilePhotoSelectionView: View {
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    var body: some View {
        ZStack {
            PhotosPicker(selection: $avatarItem, matching: .images) {
                ZStack {
                    if let avatarImage {
                        avatarImage
                            .resizable()
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundStyle(Color(uiColor: .systemGray2))
                    }
                }
                
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
            }
        }
        .onChange(of: avatarItem) { _ in
            Task {
                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                    avatarImage = loaded
                } else {
                    print("Failed")
                }
            }
        }
    }
}

#Preview {
    ProfilePhotoSelectionView()
}
