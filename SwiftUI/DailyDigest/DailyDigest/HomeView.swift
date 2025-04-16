//
//  ContentView.swift
//  DailyDigest
//
//  Created by Rishik Dev on 12/04/23.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @Environment(\.openURL) var openURL
//    @StateObject var locationManager = LocationManager()
    @StateObject var newsVM = NewsViewModel()
    @State var isTapped = false
    
    var body: some View {
        NavigationStack {
            ScrollView {                
                ForEach(newsVM.articles, id: \.url) { article in
                    NewsCell(article: article)
                        .onTapGesture {
                            openURL(URL(string: article.url ?? "https://www.google.com")!)
                        }
                        .onLongPressGesture {
                            withAnimation {
                                newsVM.toggleIsTapped(for: article)
                            }
                        }
                }
            }
            .navigationTitle("Daily Digest")
            .onAppear {
//                locationManager.requestLocation()
//                locationManager.lookUpCurrentLocation { placemark in
//                    print(placemark?.country ?? "no value")
//                }
                
                newsVM.fetchTestNews()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
