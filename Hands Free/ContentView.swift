// ContentView.swift
// Hands Free
// Created by Carlos Mbendera on 03/12/2022.

import AVFoundation
import SwiftUI
import Vision

/// An observable object representing the badge which shows the chord played.
class Badge: ObservableObject {
    @Published var chordTitle = ""
}

// Global instance of Badge
var chordInstance = Badge()

struct ContentView: View {
    
    // Array containing overlay points for finger positions.
    @State private var overlayPoints: [CGPoint] = []
    
    // Observed object for the currently played chord.
    @ObservedObject public var currentChord = chordInstance
    
    // View for displaying the camera with finger overlays.
    var cameraViewFinder: some View {
        CameraView { overlayPoints = $0 }
            .overlay(FingersOverlay(with: overlayPoints).foregroundColor(.green))
            .ignoresSafeArea()
    }
    
    // View for displaying the chord name.
    @ViewBuilder var showChord: some View {
        if currentChord.chordTitle.isEmpty {
            EmptyView()
        } else {
            ZStack {
                Circle().foregroundColor(.indigo)
                Text(currentChord.chordTitle).font(.headline)
            }
            .frame(width: 150, height: 250)
        }
    }
    
    var body: some View {
        ZStack {
            cameraViewFinder
            Text(currentChord.chordTitle)
            showChord.opacity(0.3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Shape overlay representing the fingers' positions.
struct FingersOverlay: Shape {
    let points: [CGPoint]
    private let pointsPath = UIBezierPath()
    
    init(with points: [CGPoint]) {
        self.points = points
    }
    
    // Create a path with circular markers for each point in the points array.
    func path(in rect: CGRect) -> Path {
        for point in points {
            pointsPath.move(to: point)
            pointsPath.addArc(withCenter: point, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        }
        return Path(pointsPath.cgPath)
    }
}
