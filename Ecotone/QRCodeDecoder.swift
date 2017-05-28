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
    let videoPreviewLayer: AVCaptureVideoPreviewLayer
    
    init() {
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            input = nil
            print(error)
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        addOutputAndSetMetadataObjectTypes()
    }

    // Add the capture output to the capture session, and set the capture output's
    // metadata object types. These operations must be done together, in this order.
    func addOutputAndSetMetadataObjectTypes() {
        captureSession.addOutput(captureMetadataOutput)
        // Devices that do not support AVMetadataObjectTypeQRCode, such as the simulator,
        // will crash when assigning unsupported code types. Check that the AVMetadataObjectTypeQRCode
        // type is supported before assigning.
        if let availableMetadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes as? [String],
            availableMetadataObjectTypes.contains(AVMetadataObjectTypeQRCode) {
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        }
    }
    
    func setMetadataObjectsDelegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue) {
        captureMetadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
    }

    func startRunning() {
        captureSession.startRunning()
    }
    
    func stopRunning() {
        captureSession.stopRunning()
    }

}
