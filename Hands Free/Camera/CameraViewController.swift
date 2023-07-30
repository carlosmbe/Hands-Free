//
//  CameraViewController.swift
//  Hands Free
//
//  Created by Carlos Mbendera on 03/12/2022.
//

import AVFoundation
import UIKit
import Vision

enum CameraErrors: Error {
    //TODO: Add specific error cases
    case setupError
}

final class CameraViewController: UIViewController {
    
    private var cameraFeedSession: AVCaptureSession?
    
    // Setting up the camera preview layer.
    override func loadView() {
        view = CameraPreview()
    }
    
    private var cameraView: CameraPreview { view as! CameraPreview }
    
    // On appearing, start the camera feed.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            if cameraFeedSession == nil {
                try setupAVSession()
                cameraView.previewLayer.session = cameraFeedSession
                cameraView.previewLayer.videoGravity = .resizeAspectFill
            }
            cameraFeedSession?.startRunning()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // On disappearing, stop the camera feed.
    override func viewDidDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewDidDisappear(animated)
    }
    
    // Queue for processing video data.
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedOutput", qos: .userInteractive)
    
    // Setting up the AV session.
    func setupAVSession() throws {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw CameraErrors.setupError
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw CameraErrors.setupError
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = .high
        
        guard session.canAddInput(deviceInput) else {
            throw CameraErrors.setupError
        }
        
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw CameraErrors.setupError
        }
        
        session.commitConfiguration()
        cameraFeedSession = session
    }
    
    // Vision request to detect human hand poses.
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        return request
    }()
    
    var pointsProcessorHandler: (([CGPoint]) -> Void)?

    // Convert detected points for the SwiftUI view.
    func processPoints(_ fingerTips: [CGPoint]) {
        let convertedPoints = fingerTips.map {
            cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        pointsProcessorHandler?(convertedPoints)
    }
}

// Extension to handle video data output and process it using Vision.
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        var fingerTips: [CGPoint] = []
        defer {
            DispatchQueue.main.sync {
                self.processPoints(fingerTips)
            }
        }

        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        
        do {
            try handler.perform([handPoseRequest])
            guard let results = handPoseRequest.results?.prefix(2), !results.isEmpty else {
                return
            }

            var recognizedPoints: [VNRecognizedPoint] = []

            try results.forEach { observation in
                let fingers = try observation.recognizedPoints(.all)
                magicWithHands(fingers: fingers)
            }

            fingerTips = recognizedPoints.filter {
                $0.confidence > 0.9
            }
            .map {
                CGPoint(x: $0.location.x, y: 1 - $0.location.y)
            }
        } catch {
            cameraFeedSession?.stopRunning()
        }
    }
}
