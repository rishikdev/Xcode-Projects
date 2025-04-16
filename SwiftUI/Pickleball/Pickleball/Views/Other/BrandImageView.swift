//
//  BrandImageView.swift
//  Pickleball
//
//  Created by Rishik Dev on 05/11/24.
//

import SwiftUI

struct BrandImageView: View {
    
    var body: some View {
        VStack {
            Text(Constants.Text.brandName.rawValue)
                .font(.largeTitle)
                .fontWeight(.black)
                .fontDesign(.rounded)
            
            Image(systemName: "figure.pickleball")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.ImageSize.width.rawValue)
        }
        .padding()
    }
}

#Preview {
    BrandImageView()
}

