//
//  ContentView.swift
//  PizzaApp
//
//  Created by Rishik Dev on 20/04/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CustomViews()
                .tabItem {
                    Label("Custom", systemImage: "rectangle.grid.1x2")
                }
            
            BluetoothView()
                .tabItem {
                    Label("Bluetooth", image: "logo.bluetooth")
                }
            
            QRCodeScannerView()
                .tabItem {
                    Label("QR Code", systemImage: "qrcode.viewfinder")
                }
            
            NeumorphicView()
                .tabItem {
                    Label("Neomorphism", systemImage: "circle.grid.2x2")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
