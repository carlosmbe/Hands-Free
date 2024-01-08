// ProcessingHands.swift
// Hands Free
// Created by Carlos Mbendera on 04/12/2022.

import Foundation
import Vision

/// Analyzes the positions of fingers and takes action based on their position.
func magicWithHands(fingers: [VNHumanHandPoseObservation.JointName: VNRecognizedPoint]) {
    
    guard let thumbTipPoint = fingers[.thumbTip], thumbTipPoint.confidence > 0.9 else {
        return
    }
    
    let thumbCGPoint = getFingerCGPoint(thumbTipPoint)

    // Check for Index Finger
    if let indexTipPoint = fingers[.indexTip], indexTipPoint.confidence > 0.8 {
        let indexFingerCGPoint = getFingerCGPoint(indexTipPoint)
        fingerRecognized(thumbTipCG: thumbCGPoint, otherFinger: indexFingerCGPoint, fingerName: "Index")
    }


    // Check for Little Finger
    if let ringTipPoint = fingers[.ringTip], ringTipPoint.confidence > 0.6 {
        let ringFingerCGPoint = getFingerCGPoint(ringTipPoint)
        fingerRecognized(thumbTipCG: thumbCGPoint, otherFinger: ringFingerCGPoint, fingerName: "Ring")
    }
}

/// Converts the given recognized point into a CGPoint.
func getFingerCGPoint(_ finger: VNRecognizedPoint) -> CGPoint {
    return CGPoint(x: finger.location.x, y: 1 - finger.location.y)
}

/// Calculates the squared distance between two CGPoints.
func cgPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}

/// Determines if fingers are recognized based on the distance between their positions.
func fingerRecognized(thumbTipCG: CGPoint, otherFinger: CGPoint, fingerName: String) {
    let distance = cgPointDistanceSquared(from: thumbTipCG, to: otherFinger)
    print("Distance between points is \(distance)")
    if distance < 0.01 {
        playMajorChord(root: 67, finger: fingerName) // G V
    }
}
