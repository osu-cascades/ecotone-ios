// QRCodeDecoder.swift
// Created by Yong Bakos on 5/22/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.

import AVFoundation
import UIKit

class QRCodeDecoder {
    
    let captureSession = AVCaptureSession()
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

    let dataOutput = AVCaptureMetadataOutput()
    var captured = false
    let previewLayer: AVCaptureVideoPreviewLayer?
    
    init() {
        captureSession.beginConfiguration()
        do {
            captureSession.addInput(try AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print("beginSession : \(error.localizedDescription)")
        }
        captureSession.addOutput(dataOutput)
        dataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        captureSession.commitConfiguration()
        captureSession.startRunning()
    
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
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
