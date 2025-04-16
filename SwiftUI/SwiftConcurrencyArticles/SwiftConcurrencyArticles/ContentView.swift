//
//  ContentView.swift
//  SwiftConcurrencyArticles
//
//  Created by Rishik Dev on 03/02/2025.
//

import SwiftUI

struct ContentView: View
{
    @StateObject private var postVM: PostViewModel = .init(networkManager: NetworkManager.shared)
    
    var body: some View
    {
        NavigationStack
        {
            VStack
            {
                switch postVM.fetchStatus
                {
                    case .reset:
                        resetView
                    case .initiated:
                        initiatedView
                    case .success:
                        successView
                    case .failure:
                        failureView
                }
            }
            .onAppear
            {
                Task
                {
                    await postVM.fetchPosts()
                }
            }
            .navigationTitle("Posts")
        }
    }
    
    var resetView: some View
    {
        Text("No posts yet")
    }
    
    var initiatedView: some View
    {
        ProgressView()
    }
    
    var successView: some View
    {
        List(postVM.posts) { post in
            VStack(alignment: .leading)
            {
                Text(post.title)
                    .font(.title3.bold())
                Text(post.body)
                    .font(.callout)
                    .lineLimit(2)
            }
        }
        .listStyle(.plain)
    }
    
    var failureView: some View
    {
        Text("Failed to load posts")
    }
}

#Preview
{
    ContentView()
}
