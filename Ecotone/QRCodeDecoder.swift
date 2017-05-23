// QRCodeDecoder.swift
// Created by Yong Bakos on 5/22/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.

import AVFoundation
import UIKit

class QRCodeDecoder {
    
    let captureSession = AVCaptureSession()
    let captureDevice : AVCaptureDevice?
    let dataOutput = AVCaptureVideoDataOutput()
    var captured = false
    
    init() {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                  mediaType: AVMediaTypeVideo,
                                                                  position: .back).devices {
            captureDevice = availableDevices.first
        } else {
            captureDevice = nil
        }
        
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        captureSession.beginConfiguration()
        do {
            captureSession.addInput(try AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print("beginSession : \(error.localizedDescription)")
        }
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        captureSession.commitConfiguration()
        captureSession.startRunning()
        
    }
    
    func stopCaptureSession() {
        captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
    }
    
    func getImageFromSampleBuffer(buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }

}
