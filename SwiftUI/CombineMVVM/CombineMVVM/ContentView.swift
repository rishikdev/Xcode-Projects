//
//  ContentView.swift
//  CombineMVVM
//
//  Created by Rishik Dev on 28/06/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var postVM = PostViewModel()
    @State private var count: Int = 1
    
    var body: some View {
        NavigationStack {
            VStack {
                Stepper("^[\(count) man](inflect: true)", value: $count, in: 1...2)
                    .padding()
                    
                if(postVM.isApiCallSuccessful) {
                    ScrollView {
                        ForEach(postVM.posts) { post in
                            PostCell(post: post)
                        }
                    }
                } else {
                    Text("Something went wrong. Please try again later.")
                }
            }
            .navigationTitle("Posts")
            .onAppear {
                postVM.getPosts()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
