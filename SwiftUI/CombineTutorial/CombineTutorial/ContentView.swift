//
//  ContentView.swift
//  CombineTutorial
//
//  Created by Rishik Dev on 10/04/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var pVM = PostViewModel()
    @State private var isValidURL: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if(pVM.isFetchSuccessful) {
                    List {
                        ForEach(pVM.posts) { post in
                            VStack(alignment: .leading) {
                                Text(post.title!)
                                    .font(.headline)
                                
                                Text(post.body!)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                } else {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Something went wrong.\nPlease try again later.")
                            .foregroundColor(.gray)
                        
                    }
                    .font(.largeTitle)
                    .padding()
                }
            }
            .onAppear {
                pVM.getPosts()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Toggle(isValidURL ? "Valid URL" : "Invalid URL", isOn: $isValidURL)
                    .toggleStyle(.switch)
                    .onChange(of: isValidURL) { isValid in
                        pVM.isValidURL = isValid
                        pVM.getPosts()
                    }
                }
            }
            .navigationTitle("Posts")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
