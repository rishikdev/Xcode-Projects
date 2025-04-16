//
//  ContentView.swift
//  CoverFlow
//
//  Created by Rishik Dev on 01/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showContextView: Bool =  false
    
    var body: some View {
        VStack
        {
            if(showContextView)
            {
                ContextView()
            }
            else
            {
                RecordView()
            }
        }
        .onLongPressGesture {
            withAnimation {
                showContextView.toggle()
            }
        }
    }
}

struct RecordView: View {
    @State private var hasAppeared: Bool = false
    
    var body: some View {
        Text("Record")
            .frame(width: 200, height: 200)
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 10)
            }
            .frame(width: 200, height: 200)
            .rotation3DEffect(.degrees(hasAppeared ? 0 : 180), axis: (x: 0, y: 1, z: 0))
            .onAppear {
                withAnimation(.easeInOut(duration: 2)) {
                    hasAppeared = true
                }
            }
    }
}

struct ContextView: View {
    @State private var hasAppeared: Bool = false
    
    var body: some View {
        Text("Context")
            .frame(width: 200, height: 200)
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 10)
            }
            .rotation3DEffect(.degrees(hasAppeared ? 0 : 180), axis: (x: 0, y: 1, z: 0))
            .onAppear {
                withAnimation(.easeInOut(duration: 2)) {
                    hasAppeared = true
                }
            }
    }
}

#Preview {
    ContentView()
}
