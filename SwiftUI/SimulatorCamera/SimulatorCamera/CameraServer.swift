//
//  CameraServer.swift
//  SimulatorCamera
//
//  Created by Rishik Dev on 11/06/26.
//

import AppKit
import AVFoundation
import CoreImage
import Network

import Foundation
import AVFoundation
import Network
import Observation

@Observable // 1. Add the Observation macro so SwiftUI can watch properties
class CameraServer: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private let bufferQueue = DispatchQueue(label: "camera.buffer.queue")
    
    private var listener: NWListener?
    private var activeConnections: [NWConnection] = []
    
    // 2. This property will be dynamically read by the SwiftUI view
    var statusMessage: String = "Initialising..."
    
    override init() {
        super.init()
        setupCamera()
        setupServer()
    }
    
    private func setupCamera() {
        captureSession.beginConfiguration()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            // 3. Catch Hardware failure (e.g., Camera in use by another app or no permission)
            self.statusMessage = "Error: Could not access FaceTime camera."
            return
        }
        
        if captureSession.canAddInput(videoInput) { captureSession.addInput(videoInput) }
        
        videoOutput.setSampleBufferDelegate(self, queue: bufferQueue)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        if captureSession.canAddOutput(videoOutput) { captureSession.addOutput(videoOutput) }
        captureSession.commitConfiguration()
        
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    private func setupServer() {
        do {
            let parameters = NWParameters.tcp
            self.listener = try NWListener(using: parameters, on: 8080)
            
            listener?.stateUpdateHandler = { [weak self] state in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch state {
                    case .ready:
                        self.statusMessage = "Live: Streaming on Port 8080"
                    case .failed(let error):
                        // 4. Catch asynchronous runtime network crashes (e.g., port closed suddenly)
                        self.statusMessage = "Network Failure: \(error.localizedDescription)"
                    default:
                        break
                    }
                }
            }
            
            listener?.newConnectionHandler = { [weak self] newConnection in
                self?.activeConnections.append(newConnection)
                newConnection.start(queue: .main)
            }
            
            listener?.start(queue: .main)
        } catch {
            // 5. Catch Port Collisions (e.g., another instance of this app is already running)
            self.statusMessage = "Port Error: Port 8080 already in use."
        }
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        let nsImage = NSImage(cgImage: cgImage, size: ciImage.extent.size)
        guard let tiffData = nsImage.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData),
              let jpegData = bitmapRep.representation(using: .jpeg, properties: [:]) else { return }
        
        sendFrameToClients(jpegData)
    }
    
    private func sendFrameToClients(_ data: Data) {
        activeConnections = activeConnections.filter { connection in
            switch connection.state {
            case .cancelled, .failed:
                return false
            default:
                return true
            }
        }
        
        for connection in activeConnections {
            var packet = Data()
            let length = UInt32(data.count).bigEndian
            
            withUnsafeBytes(of: length) { buffer in
                packet.append(contentsOf: buffer)
            }
            packet.append(data)
            
            connection.send(content: packet, completion: .contentProcessed({ error in
                if let error = error { print("Send error: \(error)") }
            }))
        }
    }
}
