//
//  ScoreView.swift
//  Remember Me?
//
//  Created by Rishik Dev on 18/04/22.
//

import SwiftUI

struct ScoreView: View
{
    @Binding var shouldPopToRootView: Bool
    
    @State var selectedEmoticons: [String]
    @State var correctEmoticons: [String]
    @State var score: Int = 0
    
    @State var selectedEmoticonsSet: Set<String> = Set()
    @State var correctEmoticonsSet: Set<String> = Set()
    @State var missedEmoticonsSet: Set<String> = Set()
    @State var incorrectEmoticonsSet: Set<String> = Set()
    
    @State var isVisible: Bool = false
    
    @State var columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View
    {
        VStack
        {
            ZStack
            {
                if(Double(score) / Double(correctEmoticons.count) <= 0.25)
                {
                    Color(UIColor.systemRed)
                        .ignoresSafeArea()
                        .frame(maxHeight: UIScreen.main.bounds.size.height / 5)
                }
                
                else if(Double(score) / Double(correctEmoticons.count) <= 0.75)
                {
                    Color(UIColor.systemOrange)
                        .ignoresSafeArea()
                        .frame(maxHeight: UIScreen.main.bounds.size.height / 5)
                }
                
                else
                {
                    Color(UIColor.systemGreen)
                        .ignoresSafeArea()
                        .frame(maxHeight: UIScreen.main.bounds.size.height / 5)
                }
                
                VStack
                {
                    Text("You scored")
                    Text("\(score)")
                    
                    if(Double(score) / Double(correctEmoticons.count) <= 0.25)
                    {
                        if(score == 0)
                        {
                            HStack
                            {
                                Image(systemName: "star")
                                Image(systemName: "star")
                                Image(systemName: "star")
                            }
                            .foregroundColor(.yellow)
                        }
                        
                        else
                        {
                            HStack
                            {
                                Image(systemName: "star.fill")
                                Image(systemName: "star")
                                Image(systemName: "star")
                            }
                            .foregroundColor(.yellow)
                        }
                    }
                    
                    else if(Double(score) / Double(correctEmoticons.count) <= 0.75)
                    {
                        HStack
                        {
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star")
                        }
                        .foregroundColor(.yellow)
                    }
                    
                    else
                    {
                        HStack
                        {
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                        }
                        .foregroundColor(.yellow)
                    }
                }
                .scaleEffect(isVisible ? 1 : 0)
                .animation(.easeIn, value: isVisible)
                .foregroundColor(.white)
            }
            .font(.largeTitle)
                        
            ScrollView
            {
                Text("You were shown these emoticons:")
                    .padding()
                
                LazyVGrid(columns: columns, alignment: .center, spacing: 20)
                {
                    ForEach(correctEmoticons, id: \.self)
                    {
                        correctEmoticon in
                        
                        Text(correctEmoticon)
                            .font(.system(size: 60))
                    }
                }
                
                Divider()
                
                Text("You selected these emoticons:")
                    .padding()
                
                LazyVGrid(columns: columns, alignment: .center, spacing: 20)
                {
                    ForEach(Array(correctEmoticonsSet), id: \.self)
                    {
                        correctEmoticon in
                        
                        ZStack
                        {
                            RoundedRectangle(cornerRadius: 20)
                                .opacity(0.3)
                                .foregroundColor(.green)
                                .padding()
                                .frame(width: 125, height: 125)
                                .overlay
                                {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.green)
                                        .padding()
                                        .frame(width: 125, height: 125)
                                }
                            
                            Text(correctEmoticon)
                                .font(.system(size: 60))
                                .padding()
                        }
                    }
                        
                    ForEach(Array(incorrectEmoticonsSet), id: \.self)
                    {
                        incorrectEmoticon in
                        
                        ZStack
                        {
                            RoundedRectangle(cornerRadius: 20)
                                .opacity(0.3)
                                .foregroundColor(.red)
                                .padding()
                                .frame(width: 125, height: 125)
                                .overlay
                                {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.red)
                                        .padding()
                                        .frame(width: 125, height: 125)
                                }
                            
                            Text(incorrectEmoticon)
                                .font(.system(size: 60))
                                .padding()
                        }
                    }
                }
                
                if(missedEmoticonsSet.count != 0)
                {
                    Divider()
                    
                    Text("You missed these emoticons:")
                        .padding()
                    
                    LazyVGrid(columns: columns, alignment: .center, spacing: 20)
                    {
                        ForEach(Array(missedEmoticonsSet), id: \.self)
                        {
                            missedEmoticon in
                            
                            ZStack
                            {
                                RoundedRectangle(cornerRadius: 20)
                                    .opacity(0.3)
                                    .foregroundColor(.orange)
                                    .padding()
                                    .frame(width: 125, height: 125)
                                    .overlay
                                    {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 2)
                                            .foregroundColor(.orange)
                                            .padding()
                                            .frame(width: 125, height: 125)
                                    }
                                
                                Text(missedEmoticon)
                                    .font(.system(size: 60))
                                    .padding()
                            }
                        }
                    }
                }
                
                Text("")
            }
                        
            Button(action: { self.shouldPopToRootView = false } )
            {
                Text("Home")
                    .fontWeight(.black)
                    .frame(maxWidth: UIScreen.main.bounds.size.width - 50)
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(15)
            }
            .buttonStyle(.plain)
            
            Text("")
        }
        .onAppear(perform: calculateScore)
        .navigationBarBackButtonHidden(true)
    }
    
    func calculateScore()
    {
        isVisible = true
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        }
        
        correctEmoticonsSet = Set(correctEmoticons)
        missedEmoticonsSet = Set(correctEmoticons)
        selectedEmoticonsSet = Set(selectedEmoticons)
        incorrectEmoticonsSet = Set(selectedEmoticons)
        
        missedEmoticonsSet.subtract(selectedEmoticonsSet)
        incorrectEmoticonsSet.subtract(correctEmoticonsSet)
        correctEmoticonsSet = correctEmoticonsSet.intersection(selectedEmoticonsSet)
        
//        for selectedEmoticon in selectedEmoticons
//        {
//            if(correctEmoticons.contains(selectedEmoticon))
//            {
//                score = score + 1
//            }
//
//            else
//            {
//                score = (score - 1 < 0) ? 0 : (score - 1)
//            }
//        }
        
        score = correctEmoticonsSet.count - incorrectEmoticonsSet.count < 0 ? 0 : correctEmoticonsSet.count - incorrectEmoticonsSet.count
    }
}

//struct ScoreView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        ScoreView(selectedEmoticons: [], correctEmoticons: [])
//    }
//}
