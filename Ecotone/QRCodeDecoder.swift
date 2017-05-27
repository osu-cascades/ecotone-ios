// QRCodeDecoder.swift
// Created by Yong Bakos on 5/22/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.

import AVFoundation
import UIKit

class QRCodeDecoder {
    
    let captureSession = AVCaptureSession()
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    let dataOutput = AVCaptureMetadataOutput()
    let previewLayer: AVCaptureVideoPreviewLayer
    var isReady = false
    
    init() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        captureSession.beginConfiguration()
        do {
            captureSession.addInput(try AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print("beginSession : \(error.localizedDescription)")
//            return
        }
        captureSession.addOutput(dataOutput)
        if let ots = dataOutput.metadataObjectTypes as? [String], ots.contains(AVMetadataObjectTypeQRCode) {
            self.dataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode] // CRASH
        } else {
            print(dataOutput.metadataObjectTypes) // REMOVE
//            return
        }
        captureSession.commitConfiguration()
        captureSession.startRunning()
        isReady = true
    }
    
    func setCaptureDelegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue) {
        dataOutput.setMetadataObjectsDelegate(delegate, queue: queue)
    }
    
    func stopCaptureSession() {
        captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
    }

}
