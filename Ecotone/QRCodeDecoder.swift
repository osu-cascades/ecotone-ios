// QRCodeDecoder.swift
// Created by Yong Bakos on 5/22/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.

import AVFoundation
import UIKit

class QRCodeDecoder {

    let supportedCodeTypes = [AVMetadataObjectTypeQRCode]
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    let input: AVCaptureDeviceInput?
    let captureSession = AVCaptureSession()
    let captureMetadataOutput = AVCaptureMetadataOutput()
    
    init() {
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            input = nil
            print(error)
        }
    }
    
//    func setCaptureDelegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue) {
//        dataOutput.setMetadataObjectsDelegate(delegate, queue: queue)
//    }
//    
//    func stopCaptureSession() {
//        captureSession.stopRunning()
//        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
//            for input in inputs {
//                captureSession.removeInput(input)
//            }
//        }
//    }

}
