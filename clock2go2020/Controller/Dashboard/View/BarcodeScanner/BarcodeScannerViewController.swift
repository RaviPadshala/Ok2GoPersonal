//
//  BarcodeScannerViewController.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 10.02.2022.
//

import UIKit
import AVFoundation

protocol BarcodeScannerDelegate: NSObjectProtocol {
    func didScan(taskId: String, taskName: String)
}

class BarcodeScannerViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var closeButton: UIButton!
    weak var delegate: BarcodeScannerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
                
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .upce, .code39, .code39Mod43, .code93, .code128, .qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        closeButton = UIButton(frame: CGRect(x: 10.0, y: 40.0, width: 50.0, height: 50.0))
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.addSubview(closeButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func failed() {
        captureSession = nil
    }
    
    @objc private func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension BarcodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            found(stringValue)
        }
    }
    
    func found(_ barcode: String) {
        var taskId: String = ""
        var taskName: String = ""
        let components = barcode.components(separatedBy: " ")
        if let _ = Int(components.first ?? "") {
            taskId = components.first ?? ""
            taskName = barcode.replacingOccurrences(of: taskId + " ", with: "")
        } else {
            taskId = components.last ?? ""
            taskName = barcode.replacingOccurrences(of: " " + taskId, with: "")
        }
        print("")
        dismiss(animated: true) {
            self.delegate?.didScan(taskId: taskId, taskName: taskName)
        }
    }
}
