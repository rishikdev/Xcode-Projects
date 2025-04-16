//
//  FizzBuzzView.swift
//  PizzaApp
//
//  Created by Rishik Dev on 25/05/23.
//

import SwiftUI

struct FizzBuzzView: View {
    var body: some View {
        List {
            ForEach(1..<101) { val in
                if(val % 15 == 0) {
                    Text("\(val)\t\tFizzBuzz")
                } else if(val % 3 == 0) {
                    Text("\(val)\t\tFizz")
                } else if(val % 5 == 0) {
                    Text("\(val)\t\tBuzz")
                }
            }
        }
    }
}

struct FizzBuzzView_Previews: PreviewProvider {
    static var previews: some View {
        FizzBuzzView()
    }
}
