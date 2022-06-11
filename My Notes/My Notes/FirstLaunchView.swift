//
//  FirstLaunchView.swift
//  My Notes
//
//  Created by Rishik Dev on 02/04/22.
//

import SwiftUI

struct FirstLaunchView: View
{
    @Environment(\.dismiss) var dismiss
    @StateObject var myNotesViewModel: MyNotesViewModel
    
    var body: some View
    {
        VStack()
        {
            Spacer()
        
            Text("Welcome to My Notes!")
                .font(.system(.title, design: .rounded))
                .fontWeight(.heavy)
            
            Spacer()
            
            VStack(alignment: .leading)
            {
                HStack
                {
                    Image(systemName: "circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)

                    Text("Tags help you organise your notes faster and more efficiently")
                        .font(.system(.body, design: .rounded))
                        .padding(.vertical)
                }

                HStack
                {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)

                    Text("Filter your notes with the help of tags for quick access")
                        .font(.system(.body, design: .rounded))
                        .padding(.vertical)
                }

                HStack
                {
                    Image(systemName: "lock.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)

                    Text("Use Biometric Authentication to securely save your notes")
                        .font(.system(.body, design: .rounded))
                        .padding(.vertical)
                }
            }
            
            Spacer()
            
            Button("Continue")
            {
                withAnimation
                {
                    myNotesViewModel.firstLaunch = false
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

struct FirstLaunchView_Previews: PreviewProvider
{
    static var previews: some View
    {
        FirstLaunchView(myNotesViewModel: MyNotesViewModel())
    }
}
