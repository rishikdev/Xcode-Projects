//
//  NewAlarmButton.swift
//  Alarms
//
//  Created by Rishik Dev on 01/08/23.
//

import SwiftUI

struct NewAlarmButton: View {
    var body: some View {
        Rectangle()
            .fill(Color(uiColor: .systemGray6))
            .cornerRadius(10)
            .frame(width: 150, height: 150)
            .overlay {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(Color(uiColor: .systemGray3))
            }
            .padding()
    }
}

struct NewAlarmButton_Previews: PreviewProvider {
    static var previews: some View {
        NewAlarmButton()
    }
}
