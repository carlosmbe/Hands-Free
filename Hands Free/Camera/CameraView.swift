//
//  CameraView.swift
//  Hands Free
//
//  Created by Carlos Mbendera on 03/12/2022.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable{
    
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let cvc = CameraViewController()
        cvc.pointsProcessorHandler = pointsProcessorHandler
        return cvc
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        //Not needed for this app
    }
}
