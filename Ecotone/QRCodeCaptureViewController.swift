// QRCodeCaptureViewController.swift
// Created by Nathan Struhs on 5/15/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.
// Source: http://www.appcoda.com/barcode-reader-swift

import UIKit
import AVFoundation

class QRCodeCaptureViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let qrCodeDecoder = QRCodeDecoder()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeDecoder.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        initializeVideoPreviewLayer()
    }

    private func initializeVideoPreviewLayer() {
        videoPreviewLayer = qrCodeDecoder.videoPreviewLayer
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        qrCodeDecoder.startRunning()
    }
    
    // AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [Any]!,
                       from connection: AVCaptureConnection!) {
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            qrCodeDecoder.supportedCodeTypes.contains(metadataObj.type),
            let qrCodeDecodedString = metadataObj.stringValue {
                showURLInWebApplicationTab(url: qrCodeDecodedString)
        }
    }
    
    private func showURLInWebApplicationTab(url: String) {
        if let webAppViewController = tabBarController?.viewControllers?[0] as? WebAppViewController {
            webAppViewController.loadURL(url)
        }
        tabBarController?.selectedIndex = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        qrCodeDecoder.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
