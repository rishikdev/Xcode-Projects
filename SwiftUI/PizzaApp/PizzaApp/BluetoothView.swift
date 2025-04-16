//
//  BluetoothView.swift
//  PizzaApp
//
//  Created by Rishik Dev on 03/05/23.
//

import SwiftUI
import CoreBluetooth

private class BluetoothViewModel: NSObject, ObservableObject {
    @Published var peripheralNames: [String] = []
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn) {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(!self.peripherals.contains(peripheral)) {
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "Unknown Device")
        }
    }
}

struct BluetoothView: View {
    @StateObject private var btVM = BluetoothViewModel()
    
    var body: some View {
        NavigationStack {
            List(btVM.peripheralNames, id: \.self) { btDevice in
                Text(btDevice)
            }
            .navigationTitle("Bluetooth")
        }
    }
}

struct BluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothView()
    }
}
