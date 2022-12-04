//
//  ContentView.swift
//  Hands Free
//
//  Created by Carlos Mbendera on 03/12/2022.
//

import AVFoundation
import SwiftUI
import Vision

struct ContentView: View {
    
    @State private var overlayPoints: [CGPoint] = []
    
    var body: some View {
        ZStack {
            CameraView {    overlayPoints = $0  }
            .overlay(FingersOverlay(with: overlayPoints)
                    .foregroundColor(.green)
                )
            .ignoresSafeArea()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FingersOverlay: Shape {
    let points: [CGPoint]
    private let pointsPath = UIBezierPath()
    
    init(with points: [CGPoint]) {
        self.points = points
    }
    
    func path(in rect: CGRect) -> Path {
        for point in points {
            pointsPath.move(to: point)
            pointsPath.addArc(withCenter: point, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        }
        
        return Path(pointsPath.cgPath)
    }
}
