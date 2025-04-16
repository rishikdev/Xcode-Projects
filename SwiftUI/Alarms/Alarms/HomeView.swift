//
//  ContentView.swift
//  Alarms
//
//  Created by Rishik Dev on 01/08/23.
//

import SwiftUI

struct HomeView: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var showAlarmSettings: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    NewAlarmButton()
                        .onTapGesture {
                            showAlarmSettings.toggle()
                        }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAlarmSettings.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }

                    }
                }
                .sheet(isPresented: $showAlarmSettings) {
                    AlarmSettingsView()
                }
            }
            .navigationTitle("Alarms")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            
            HomeView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
