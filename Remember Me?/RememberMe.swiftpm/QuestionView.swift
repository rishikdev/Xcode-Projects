//
//  QuestionView.swift
//  Remember Me?
//
//  Created by Rishik Dev on 18/04/22.
//

import SwiftUI

struct QuestionView: View
{
    @Binding var rootIsActive: Bool
    @State var correctEmoticons: [String]
    @State var selectedEmoticons: [String] = []
    @State var isEmoticonSelected: Bool  = false
    @State var emoticonsRandomSample: [String]
    
    @State var columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View
    {
        VStack
        {
            ScrollView
            {
                LazyVGrid(columns: columns, alignment: .center, spacing: 20)
                {
                    ForEach(emoticonsRandomSample, id: \.self)
                    {
                        emoticon in
                        
                        EmoticonCell(emoticon: emoticon, isSelected: self.selectedEmoticons.contains(emoticon))
                        {
                            if(self.selectedEmoticons.contains(emoticon))
                            {
                                self.selectedEmoticons.removeAll(where: { $0 == emoticon } )
                            }
                            
                            else
                            {
                                self.selectedEmoticons.append(emoticon)
                            }
                        }
                    }
                }
            }
            .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Text("\(selectedEmoticons.count)")
                }
            }
            
            NavigationLink(destination: ScoreView(shouldPopToRootView: self.$rootIsActive, selectedEmoticons: selectedEmoticons, correctEmoticons: correctEmoticons))
            {
                Text("Submit")
                    .fontWeight(.black)
                    .frame(maxWidth: UIScreen.main.bounds.size.width - 50)
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(15)
            }
            .isDetailLink(false)
            .buttonStyle(.plain)
            
            Text("")
            
        }
        .onAppear(perform: checkDeviceType)
        .navigationTitle("Which emoticons did you see?")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    func checkDeviceType()
    {
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        }
    }
}

struct EmoticonCell: View
{
    var emoticon: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View
    {
        Button(action: self.action)
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 20)
                    .opacity(isSelected ? 1 : 0)
                    .foregroundColor(.blue)
                    .opacity(0.5)
                    .padding()
                    .frame(width: 125, height: 125)
                    .overlay
                    {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(width: 125, height: 125)
                            .opacity(isSelected ? 1 : 0)
                    }
                
                Text(self.emoticon)
                    .font(.system(size: 50))
                    .padding()
            }
        }
        .buttonStyle(.plain)
    }
}

//struct QuestionView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        QuestionView(correctEmoticons: [], emoticonsRandomSample: [])
//    }
//}
