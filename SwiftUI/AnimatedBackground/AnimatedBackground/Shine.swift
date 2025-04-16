//
//  Shine.swift
//  AnimatedBackground
//
//  Created by Rishik Dev on 18/07/23.
//

import SwiftUI

struct Shine: View {
    @State private var isShineAnimating: Bool = false
    @State private var startPoint: CGFloat = -1.1 * UIScreen.main.bounds.width
    @State private var endPoint: CGFloat = 1.1 * UIScreen.main.bounds.width
    
    var width: CGFloat?
    var height: CGFloat?
    var angle: Double?
    var duration: Double?
    var distanceFromScreenEdges: Double?
    
    var body: some View {
        Rectangle()
            .fill(.white)
            .frame(width: width ?? 50, height: height ?? 150)
            .shadow(color: .white, radius: 20)
            .rotationEffect(Angle(degrees: angle ?? 45))
            .position(x: isShineAnimating ? endPoint : startPoint,
                      y: 25)
            .animation(.linear(duration: duration ?? 5).repeatForever(autoreverses: false),
                       value: isShineAnimating)
            .onAppear {
                startPoint = (distanceFromScreenEdges ?? 1.1) * UIScreen.main.bounds.width * -1
                endPoint = (distanceFromScreenEdges ?? 1.1) * UIScreen.main.bounds.width
                isShineAnimating = true
            }
    }
}

struct Shine_Previews: PreviewProvider {
    static var previews: some View {
        Shine()
            .preferredColorScheme(.dark)
    }
}
