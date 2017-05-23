// QRCodeCaptureViewController.swift
// Created by Nathan Struhs on 5/15/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.
// Source: https://www.youtube.com/watch?v=Zv4cJf5qdu0

import UIKit
import AVFoundation

class QRCodeCaptureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let qrCodeDecoder = QRCodeDecoder()
    
    var previewLayer:CALayer!

    var takePhoto = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        if qrCodeDecoder.captureDevice != nil {
            beginSession()
        }
    }

    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: qrCodeDecoder.captureDevice)
            qrCodeDecoder.captureSession.addInput(captureDeviceInput)
        } catch {
            print("beginSession : \(error.localizedDescription)")
        }

        if let previewLayer = AVCaptureVideoPreviewLayer(session: qrCodeDecoder.captureSession) {
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            qrCodeDecoder.captureSession.startRunning()

            if qrCodeDecoder.captureSession.canAddOutput(qrCodeDecoder.dataOutput) {
                qrCodeDecoder.captureSession.addOutput(qrCodeDecoder.dataOutput)
            }

            qrCodeDecoder.captureSession.commitConfiguration()

            let queue = DispatchQueue(label: "com.ecotone.captureQueue")
            qrCodeDecoder.dataOutput.setSampleBufferDelegate(self, queue: queue)

        }
    }

    @IBAction func takePhoto(_ sender: Any) {
        takePhoto = true
    }
    
    // AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if takePhoto {
            takePhoto = false
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
