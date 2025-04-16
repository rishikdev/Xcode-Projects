//
//  QRCodeScannerView.swift
//  PizzaApp
//
//  Created by Rishik Dev on 04/05/23.
//

import SwiftUI
import AVKit

struct QRCodeScannerView: View {
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var qrCodeOutput: AVCaptureMetadataOutput = .init()
    @State private var cameraPermission: CameraPermission = .idle
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var scannedCode: String = ""
    
    @Environment(\.openURL) private var openURL
    
    @StateObject private var qrDelegate = QRScannerDelegate()
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Place QR code inside the area")
                .font(.title3)
                .foregroundColor(.black.opacity(0.8))
                .padding(.top, 20)
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundColor(.gray)
                .padding()
            
            Spacer(minLength: 0)
            
            VStack {
                GeometryReader {
                    let size = $0.size
                    
                    ZStack {
                        CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
                            .scaleEffect(0.95)
                        
                        ForEach(0...4, id: \.self) { index in
                            let rotation = Double(index) * 90
                            
                            RoundedRectangle(cornerRadius: 2, style: .circular)
                                .trim(from: 0.61, to: 0.64)
                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                .rotationEffect(.init(degrees: rotation))
                            
                        }
                    }
                    /// Square shape
                    .frame(width: size.width, height: size.width)
                    /// Scanner animation
                    .overlay(alignment: .top, content: {
                        Rectangle()
                            .fill(.blue)
                            .frame(height: 2.5)
                            .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                            .offset(y: isScanning ? size.width : 0)
                    })
                    /// To make it center
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                .padding(.horizontal, 45)
            }
            .onAppear {
                checkCameraPermission()
            }
            .alert(errorMessage, isPresented: $showError) {
                /// Showing Setting's button if camera permission is denied
                if(cameraPermission == .denied) {
                    Button("Settings") {
                        let settingsString = UIApplication.openSettingsURLString
                        if let settingsURL = URL(string: settingsString) {
                            /// Opening Settings application
                            openURL(settingsURL)
                        }
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
            }
            .onDisappear {
                session.stopRunning()
            }
            .onChange(of: qrDelegate.scannedCode) { newValue in
                if let code = newValue {
                    scannedCode = code
                    /// When the first code is available, immediately stop the camera
                    session.stopRunning()
                    
                    /// Stop scanner animation
                    deactivateScannerAnimation()
                    
                    /// Clearing the data in delegate
                    qrDelegate.scannedCode = nil
                }
            }
            
            Spacer(minLength: 15)
            
            Button {
                if(!session.isRunning && cameraPermission == .approved) {
                    reactivateCamera()
                    activateScannerAnimation()
                    scannedCode = ""
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
            }
            
            Button("Visit website") {
                openURL(URL(string: scannedCode) ?? URL(string: "https://www.google.com")!)
            }
            .disabled(scannedCode.isEmpty)
        }
        .padding(15)
    }
    
    func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    /// Activating scanner animation function
    func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    /// Deactivating scanner animation function
    func deactivateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    /// Checking camera permission
    func checkCameraPermission() {
        Task {
            switch(AVCaptureDevice.authorizationStatus(for: .video)) {
            case .authorized:
                cameraPermission = .approved
                if(session.inputs.isEmpty) {
                    setUpCamera()
                } else {
                    reactivateCamera()
                }
            case .notDetermined:
                /// Requesting camera access
                if await (AVCaptureDevice.requestAccess(for: .video)) {
                    /// Permission granted
                    cameraPermission = .approved
                    setUpCamera()
                } else {
                    /// Permission denied
                    cameraPermission = .denied
                    /// Presenting error message
                    presentError("Please provide access to camera to enable scanning of QR codes.")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please provide access to camera to enable scanning of QR codes.")
            default: break
            }
        }
    }
    
    /// Setting up camera
    func setUpCamera() {
        do {
            /// Finding the back camera
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera], mediaType: .video, position: .back).devices.first else {
                presentError("Unknown Error Occured")
                return
            }
            
            /// Camera Input
            let input = try AVCaptureDeviceInput(device: device)
            
            /// For added safety, checking whether input and output can be added to the session
            guard session.canAddInput(input), session.canAddOutput(qrCodeOutput) else {
                presentError("Unknown Error Occured")
                return
            }
            
            /// Adding input and output to session
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrCodeOutput)
            
            /// Setting output config to read QR codes
            qrCodeOutput.metadataObjectTypes = [.qr]
            
            /// Adding delegate to retrieve the fetched qr code from camera
            qrCodeOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            /// Session must be started on background thread
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
            
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    /// Presenting error
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
}

struct QRCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScannerView()
    }
}
