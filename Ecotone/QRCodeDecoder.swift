// QRCodeDecoder.swift
// Created by Yong Bakos on 5/22/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.
// Ref: https://developer.apple.com/library/content/samplecode/AVMetadataRecordPlay/Listings/Swift_AVMetadataRecordPlay_CameraViewController_swift.html
// Ref: https://developer.apple.com/library/content/documentation/AudioVideo/Conceptual/PhotoCaptureGuide/
// Ref: https://developer.apple.com/library/content/samplecode/AVCaptureLocation/Listings/AVCaptureLocation_AAPLCaptureManager_m.html

import AVFoundation
import UIKit

class QRCodeDecoder {

    let captureSession = AVCaptureSession()
    let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    let input: AVCaptureDeviceInput?
    let captureMetadataOutput = AVCaptureMetadataOutput()
    let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    let videoPreviewLayer: AVCaptureVideoPreviewLayer
    
    init() {
        do {
            if let captureDevice = captureDevice {
                input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input!)
            } else {
                input = nil
            }
        } catch {
            input = nil
            print(error)
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        addOutputAndSetMetadataObjectTypes()
    }

    // Add the capture output to the capture session, and set the capture output's
    // metadata object types. These operations must be done together, in this order.
    private func addOutputAndSetMetadataObjectTypes() {
        captureSession.addOutput(captureMetadataOutput)
        // Devices that do not support AVMetadataObjectTypeQRCode, such as the simulator,
        // will crash when assigning unsupported code types. Check that the AVMetadataObjectTypeQRCode
        // type is supported before assigning.
        if captureMetadataOutput.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.qr) {
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        }
    }
    
    func setMetadataObjectsDelegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue) {
        captureMetadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
    }

    func startRunning() {
        // TODO: Dispatch async. This is a blocking call.
        // Other operations for session config must use the same thread, according to Apple docs.
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func stopRunning() {
        // TODO: Dispatch async. This is a blocking call.
        // Other operations for session config must use the same thread, according to Apple docs.
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

}
