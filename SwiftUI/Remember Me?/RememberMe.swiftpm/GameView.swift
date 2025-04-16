//
//  GameView.swift
//  Remember Me?
//
//  Created by Rishik Dev on 16/04/22.
//

import SwiftUI

struct GameView: View
{
    @Binding var rootIsActive: Bool
    @State var correctEmoticons: [String]                // This array of emoticons will be shown to the user
    @State var correctEmoticonsCount: Double
        
    @State var incorrectEmoticons: [String] = []         // This array of emoticons contains emoticons other than correctEmoticons
    @State var emoticonsRandomSample: [String] = []      // This array of emoticons is a mixture of correctEmoticons and incorrectEmoticons
    @State var index: Int = 0
    
    @State var countdownTime: Float = 3.0
    @State var totalTime: Float = 3.0
    @State var timeOver: Bool = false
    
    @State var gameStart: Bool = false
    @State var showQuestionView: Bool = false
    
    @State var countdownTimerProgressWidth: CGFloat = 150
    @State var countdownTimerProgressHeight: CGFloat = 150
    @State var countdownTimerProgressLineWidth: CGFloat = 15.0
    
    let maxSize = UIScreen.main.bounds.size.width - 225
    
    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // The user is given 30s to memorise the emoticons, and the default emoticons size is 10, thus update emoticons every 3s
    @State var emoticonTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View
    {
        ZStack
        {
            VStack(alignment: .center)
            {
                if(correctEmoticonsCount == 10)
                {
                    HStack
                    {
                        Text("Difficulty:")
                        Text("Easy")
                            .fontWeight(.black)
                            .foregroundColor(.green)
                    }
                }
                
                else if(correctEmoticonsCount == 15)
                {
                    HStack
                    {
                        Text("Difficulty:")
                        Text("Medium")
                            .fontWeight(.black)
                            .foregroundColor(.orange)
                    }
                }
                
                else
                {
                    HStack
                    {
                        Text("Difficulty:")
                        Text("Hard")
                            .fontWeight(.black)
                            .foregroundColor(.red)
                    }
                }
                
                Divider()
                
                Spacer()
            }
            .font(.largeTitle)
            .padding()
            
            VStack
            {
                countdownTimerProgress(countdownTime: $countdownTime, totalTime: $totalTime, lineWidth: $countdownTimerProgressLineWidth, gameStart: $gameStart)
                    .frame(width: countdownTimerProgressWidth, height: countdownTimerProgressHeight)
                    .padding()
                    .onReceive(countdownTimer)
                    {
                        _ in
                        countdown()
                    }
                    .animation(.linear, value: countdownTimerProgressWidth)
            }
            
            if(gameStart)
            {
                VStack
                {
                    withAnimation
                    {
                        Text(correctEmoticons[index])
                            .fontWeight(.black)
                            .font(.system(size: min(maxSize, 120)))
                            .transition(.scale)
                            .onReceive(emoticonTimer)
                            {
                                _ in
                                index = index < correctEmoticons.count - 1 ? (index + 1) : correctEmoticons.count - 1
                            }
                            .id("index " + correctEmoticons[index])
                    }
                }
                .animation(.easeInOut, value: index)
            }
            
            if(countdownTime == 0 && timeOver)
            {
                NavigationLink(destination: QuestionView(rootIsActive: $rootIsActive, correctEmoticons: correctEmoticons, emoticonsRandomSample: emoticonsRandomSample),
                               isActive: $showQuestionView)
                {
                    EmptyView()
                }
                .isDetailLink(false)
            }
            
        }
        .onAppear
        {
            emoticonTimer = Timer.publish(every: TimeInterval(30.0 / correctEmoticonsCount), on: .main, in: .common).autoconnect()
            sampleRandomEmoticons()
        }
        .onDisappear
        {
            self.emoticonTimer.upstream.connect().cancel()
            self.countdownTimer.upstream.connect().cancel()
        }
    }
    
    func countdown()
    {
        if(countdownTime > 0)
        {
            self.countdownTime = self.countdownTime - 1
        }
        
        else if(countdownTime == 0 && !timeOver)
        {
            countdownTime = 30.0
            totalTime = 30.0
            timeOver = true
            gameStart = true
            showQuestionView = true
            countdownTimerProgressWidth = min(maxSize, 140) + 100
            countdownTimerProgressHeight = min(maxSize, 140) + 100
            countdownTimerProgressLineWidth = countdownTimerProgressLineWidth / 2
        }
    }
    
    func sampleRandomEmoticons()
    {
        incorrectEmoticons = []
        emoticonsRandomSample = []
        
        for emoji in emojis
        {
            if(!correctEmoticons.contains(emoji))
            {
                incorrectEmoticons.append(emoji)
            }
        }
                        
        for _ in 0..<Int(correctEmoticonsCount) + 10
        {
            incorrectEmoticons.shuffle()
            emoticonsRandomSample.append(incorrectEmoticons.removeLast())
        }
                
        emoticonsRandomSample.append(contentsOf: correctEmoticons)
        emoticonsRandomSample.shuffle()        
    }
}

struct countdownTimerProgress: View
{
    @Binding var countdownTime: Float
    @Binding var totalTime: Float
    @Binding var lineWidth: CGFloat
    @Binding var gameStart: Bool
    
    var body: some View
    {
        ZStack
        {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(gameStart && countdownTime <= 15 ? (countdownTime <= 7 ? .red : .orange) : .green)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(countdownTime / totalTime))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(gameStart && countdownTime <= 15 ? (countdownTime <= 7 ? .red : .orange) : .green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: countdownTime)
            
            if(!gameStart)
            {
                Text(countdownTime >= 2  ? "Ready" : (countdownTime >= 1 ? "Set" : "Go!"))
                    .font(lineWidth == 15 ? .largeTitle : .title2)
                    .bold()
                    .foregroundColor(.green)
                    .animation(.linear, value: lineWidth)
            }
        }
    }
}

//struct GameView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        GameView(randomEmoticons: [""])
//    }
//}
