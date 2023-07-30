//
//  CameraView.swift
//  Hands Free
//
//  Created by Carlos Mbendera on 03/12/2022.
//

import SwiftUI

/// A SwiftUI view that represents a `CameraViewController`.
struct CameraView: UIViewControllerRepresentable {
    
    // A closure that processes an array of CGPoint values.
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    
    /// Create the associated `UIViewController` for this SwiftUI view.
    func makeUIViewController(context: Context) -> CameraViewController {
        let cvc = CameraViewController()
        cvc.pointsProcessorHandler = pointsProcessorHandler
        return cvc
    }
    
    /// Update the associated `UIViewController` for this SwiftUI view.
    /// Currently not implemented as it is not needed for this app.
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) { }
}
