//
//  HomeView.swift
//  Dhwani
//
//  Created by Rishik Dev on 26/03/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var audios: [String] = [
        "Akele Akele Kahan Ja Rahe Ho - Bollywood Classic Song in 4K | Shammi Kapoor | Mohammed Rafi Songs",
        "Mere Mehboob Qayamat Hogi  (Original) - Mr. X In Bombay - Kishore Kumar's Greatest Hits - Old Songs",
        "Roop Tera Mastana 4K Song | Aradhana Movie | Rajesh Khanna | Sharmila Tagore | Kishore Kumar"
    ]
    @State private var value: Float = 0.25
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(audios, id: \.self) { audio in
                        Text(audio)
                            .lineLimit(1)
                    }
                }
                .listStyle(.plain)
                
                VStack(spacing: 30) {
                    ProgressView(value: value)
                        .progressViewStyle(.linear)
                    
                    HStack(spacing: 30) {
                        Button {
                            
                        } label: {
                            Image(systemName: "backward.fill")
                        }

                        Button {
                            
                        } label: {
                            Image(systemName: "play.fill")
                        }
                        .font(.largeTitle)
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "forward.fill")
                        }
                    }
                }
                .buttonStyle(.plain)
                .font(.title2)
            }
            .navigationTitle("Dhwani")
        }
    }
}

#Preview {
    HomeView()
}
