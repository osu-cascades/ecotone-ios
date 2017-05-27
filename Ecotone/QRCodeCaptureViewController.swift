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
    let sampleBufferDelegateQueueName = "com.ecotone.captureQueue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeDecoder.setCaptureDelegate(self, queue: DispatchQueue(label: sampleBufferDelegateQueueName))
        qrCodeDecoder.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        qrCodeDecoder.previewLayer.frame = view.layer.bounds
        self.view.layer.addSublayer(qrCodeDecoder.previewLayer)
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        self.view.addSubview(qrCodeFrameView)
        self.view.bringSubview(toFront: qrCodeFrameView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // TODO
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
