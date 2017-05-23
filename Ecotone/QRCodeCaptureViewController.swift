// QRCodeCaptureViewController.swift
// Created by Nathan Struhs on 5/15/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.
// Source: https://www.youtube.com/watch?v=Zv4cJf5qdu0

import UIKit
import AVFoundation

class QRCodeCaptureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let qrCodeDecoder = QRCodeDecoder()
    
    var previewLayer:CALayer!
    var captureDevice : AVCaptureDevice!
    var takePhoto = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        prepareCamera()
    }

    func prepareCamera() {
        qrCodeDecoder.captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back).devices {
            captureDevice = availableDevices.first
            beginSession()
        }
    }

    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            qrCodeDecoder.captureSession.addInput(captureDeviceInput)
        } catch {
            print("beginSession : \(error.localizedDescription)")
        }

        if let previewLayer = AVCaptureVideoPreviewLayer(session: qrCodeDecoder.captureSession) {
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            qrCodeDecoder.captureSession.startRunning()

            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)]

            dataOutput.alwaysDiscardsLateVideoFrames = true

            if qrCodeDecoder.captureSession.canAddOutput(dataOutput) {
                qrCodeDecoder.captureSession.addOutput(dataOutput)
            }

            qrCodeDecoder.captureSession.commitConfiguration()

            let queue = DispatchQueue(label: "com.ecotone.captureQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)

        }
    }

    @IBAction func takePhoto(_ sender: Any) {
        takePhoto = true
    }

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if takePhoto {
            takePhoto = false
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlantAndPlotViewController") as! PlantAndPlotViewController

                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: {
                            self.stopCaptureSession()
                        })
                    }
                }
            }
        }
    }

    func getImageFromSampleBuffer (buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()

            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))

            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }

    func stopCaptureSession() {
        qrCodeDecoder.captureSession.stopRunning()
        if let inputs = qrCodeDecoder.captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                qrCodeDecoder.captureSession.removeInput(input)
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
