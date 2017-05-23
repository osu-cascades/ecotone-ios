// QRCodeCaptureViewController.swift
// Created by Nathan Struhs on 5/15/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.
// Source: https://www.youtube.com/watch?v=Zv4cJf5qdu0

import UIKit
import AVFoundation

class QRCodeCaptureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let qrCodeDecoder = QRCodeDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeDecoder.setSampleBufferDelegate(self, queue: DispatchQueue(label: "com.ecotone.captureQueue"))
        if let previewLayer = qrCodeDecoder.previewLayer {
            self.view.layer.addSublayer(previewLayer)
            previewLayer.frame = self.view.layer.frame
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }

    @IBAction func takePhoto(_ sender: Any) {
        qrCodeDecoder.captured = true
    }
    
    // AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if qrCodeDecoder.captured {
            qrCodeDecoder.captured = false
            if let image = self.qrCodeDecoder.getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlantAndPlotViewController") as! PlantAndPlotViewController

                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: {
                            self.qrCodeDecoder.stopCaptureSession()
                        })
                    }
                }
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
