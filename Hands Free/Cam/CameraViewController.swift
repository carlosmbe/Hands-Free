//
//  CameraViewController.swift
//  Hands Free
//
//  Created by Carlos Mbendera on 03/12/2022.
//

import AVFoundation
import UIKit
import Vision

enum errors: Error{
    case TooLazyToWrite
}

final class CameraViewController : UIViewController{
    
    private var cameraFeedSession: AVCaptureSession?
    
    override func loadView() {
        view = CameraPreview()
    }
    
    private var cameraView: CameraPreview{ view as! CameraPreview}
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do{
            if cameraFeedSession == nil{
                try setupAVSession()
                cameraView.previewLayer.session = cameraFeedSession
                cameraView.previewLayer.videoGravity = .resizeAspectFill
            }
            cameraFeedSession?.startRunning()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewDidDisappear(animated)
    }
    
    private let videoDataOutputQueue =
        DispatchQueue(label: "CameraFeedOutput", qos: .userInteractive)
    
    
    func setupAVSession() throws {
        //Start of setup
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw errors.TooLazyToWrite
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else{
            throw errors.TooLazyToWrite
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        guard session.canAddInput(deviceInput) else{
            throw errors.TooLazyToWrite
        }
        
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput){
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        }else{
            throw errors.TooLazyToWrite
        }
        
        session.commitConfiguration()
        cameraFeedSession = session
    }
    
    
    // Vision Stuff Below
    
    private let handPoseRequest : VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 2
        return request
    }()
    
 
    var pointsProcessorHandler: (([CGPoint]) -> Void)?

    func processPoints(_ fingerTips: [CGPoint]) {
      
      let convertedPoints = fingerTips.map {
        cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
      }

      pointsProcessorHandler?(convertedPoints)
    }
    
}


extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    //Handler and Observation
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        var fingerTips: [CGPoint] = []
        defer {
          DispatchQueue.main.sync {
            self.processPoints(fingerTips)
          }
        }


        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer,   orientation: .up,   options: [:])
        
        do{
            try handler.perform([handPoseRequest])
            
            guard let results = handPoseRequest.results?.prefix(2),     !results.isEmpty  else{
                return
            }
            
            print(results)
            //Drawing results
            
            var recognizedPoints: [VNRecognizedPoint] = []
            
            try results.forEach { observation in
              
              let fingers = try observation.recognizedPoints(.all)

              if let thumbTipPoint = fingers[.thumbTip] {
                recognizedPoints.append(thumbTipPoint)
              }
              if let indexTipPoint = fingers[.indexTip] {
                recognizedPoints.append(indexTipPoint)
              }
              if let middleTipPoint = fingers[.middleTip] {
                recognizedPoints.append(middleTipPoint)
              }
              if let ringTipPoint = fingers[.ringTip] {
                recognizedPoints.append(ringTipPoint)
              }
              if let littleTipPoint = fingers[.littleTip] {
                recognizedPoints.append(littleTipPoint)
              }
            }
            
            fingerTips = recognizedPoints.filter {
              $0.confidence > 0.9
            }
            .map {
              // Vision algorithms use a coordinate system with lower left origin and return normalized values relative to the pixel dimension of the input image. AVFoundation coordinates have an upper-left origin, so you convert the y-coordinate.
              CGPoint(x: $0.location.x, y: 1 - $0.location.y)
            }
            
            
        }catch{
            cameraFeedSession?.stopRunning()
        }
        
    }
    
}

