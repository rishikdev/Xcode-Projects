//
//  ContentView.swift
//  CocoaPodsTest
//
//  Created by Rishik Dev on 19/04/23.
//

import SwiftUI

struct PostsView: View {
    @StateObject private var postsVM = PostViewModel()
    @State private var isValidURL: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if(postsVM.isFetchSuccessful) {
                    List {
                        ForEach(postsVM.posts) { post in
                            VStack(alignment: .leading) {
                                Text(post.title ?? "No Title")
                                    .font(.headline)
                                Text(post.body ?? "")
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
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem {
                    Toggle(isValidURL ? "Valid URL" : "Invalid URL", isOn: $isValidURL)
                        .toggleStyle(.switch)
                        .onChange(of: isValidURL) { newValue in
                            postsVM.isValidURL = newValue
                            postsVM.getPostsUsingObjectMapper()
                        }
                }
            }
            .onAppear {
                postsVM.getPostsUsingObjectMapper()
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
