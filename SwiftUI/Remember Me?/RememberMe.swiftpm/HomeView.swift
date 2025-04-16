import SwiftUI

struct HomeView: View
{
    @State var isActive: Bool = false
    @State var correctEmoticons: [String] = []
    @State var emojisCopy: [String] = []
    @State var index = 0
    @State var rateOfChange = 3
    @State var timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    @AppStorage("emoticonsCount") var emoticonsCount: Double = 10
    @Environment(\.colorScheme) var colorScheme
    
    let maxSize = UIScreen.main.bounds.size.width - 200
    
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                Color(colorScheme == .light ? UIColor.systemGray6 : UIColor.black)
                    .ignoresSafeArea()
                
                VStack
                {
                    Form
                    {
                        Section(header: Text("Choose difficulty"))
                        {
                            Slider(value: $emoticonsCount, in: 10...20, step: 5)
                            
                            if(emoticonsCount == 10)
                            {
                                HStack
                                {
                                    Text("Easy")
                                        .foregroundColor(.green)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Text("\(Int(emoticonsCount))")
                                }
                            }
                            
                            else if(emoticonsCount == 15)
                            {
                                HStack
                                {
                                    Text("Medium")
                                        .foregroundColor(.orange)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Text("\(Int(emoticonsCount))")
                                }
                            }
                            
                            else
                            {
                                HStack
                                {
                                    Text("Hard")
                                        .foregroundColor(.red)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Text("\(Int(emoticonsCount))")
                                }
                            }
                        }
                    }
                    .onChange(of: emoticonsCount)
                    {
                        _ in
                        
                        if(emoticonsCount == 10)
                        {
                            rateOfChange = 3
                        }
                        
                        else if(emoticonsCount == 15)
                        {
                            rateOfChange = 2
                        }
                        
                        else
                        {
                            rateOfChange = 1
                        }
                        
                        generateRandomEmoticons()
                    }
                                        
                    Circle()
                        .padding(.horizontal)
                        .foregroundColor(colorScheme == .light ? Color(UIColor.systemGray6) : .black)
                        .overlay
                        {
                            VStack
                            {
                                Text(emojis.randomElement()!)
                                    .font(.system(size: min(maxSize, 140)))
                                    .transition(Bool.random() ? (Bool.random() ? .slide : .move(edge: .bottom)) : .scale)
                                    .onReceive(timer)
                                    {
                                        _ in
                                        index = index + 1 == emojis.count ? 0 : index + 1
                                    }
                                    .id(index)
                            }
                            .animation(.linear, value: index)
                        }
                                                        
                    NavigationLink(destination: GameView(rootIsActive: self.$isActive, correctEmoticons: correctEmoticons, correctEmoticonsCount: Double(emoticonsCount)),
                                   isActive: self.$isActive)
                    {
                        Text("Start Game")
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
                .onAppear(perform: generateRandomEmoticons)
                .onDisappear
                {
                    self.timer.upstream.connect().cancel()
                }
                .navigationTitle("Remember Me?")
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func generateRandomEmoticons()
    {
        self.timer = Timer.publish(every: TimeInterval(rateOfChange), on: .current, in: .common).autoconnect()
        
        correctEmoticons = []
        emojisCopy = []
        
        for emoji in emojis
        {
            emojisCopy.append(emoji)
        }
        
        for _ in 0..<Int(emoticonsCount)
        {
            emojisCopy.shuffle()
            correctEmoticons.append(emojisCopy.removeLast())            
        }        
    }
}
