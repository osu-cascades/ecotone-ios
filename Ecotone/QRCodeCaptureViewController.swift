// QRCodeCaptureViewController.swift
// Created by Nathan Struhs on 5/15/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.
// Source: https://www.youtube.com/watch?v=Zv4cJf5qdu0
// Source: http://www.appcoda.com/barcode-reader-swift

import UIKit
import AVFoundation

class QRCodeCaptureViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let qrCodeDecoder = QRCodeDecoder()
    let qrCodeFrameView = UIView()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeDecoder.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        initializeVideoPreviewLayer()
        initializeQRCodeFrame()
    }

    func initializeVideoPreviewLayer() {
        videoPreviewLayer = qrCodeDecoder.videoPreviewLayer
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
    }

    func initializeQRCodeFrame() {
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView)
        view.bringSubview(toFront: qrCodeFrameView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    // AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [Any]!,
                       from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.isEmpty {
            qrCodeFrameView.frame = CGRect.zero
            return
        }
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            qrCodeDecoder.supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
