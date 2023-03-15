//
//  ContentView.swift
//  Hands Free
//
//  Created by Carlos Mbendera on 03/12/2022.
//

import AVFoundation
import SwiftUI
import Vision


class Badge: ObservableObject {
    //This shows which chord was played as a view
    @Published var ChordTitle = ""
}

var ChordInstance = Badge()

struct ContentView: View {
    
    //MARK: Overlays work. Not using overlay array with chords right nnow. Mainly for debugging
    @State private var overlayPoints: [CGPoint] = []
    
    @ObservedObject public var currentChord = ChordInstance
    
    var CameraViewFinder : some View{
        CameraView {    overlayPoints = $0  }
            .overlay(FingersOverlay(with: overlayPoints)
                .foregroundColor(.green)
            )
            .ignoresSafeArea()
        
    }
    
    @ViewBuilder var showChord : some View{
        if currentChord.ChordTitle == ""{
            EmptyView()
        }else{
            ZStack{
                Circle()
                    .foregroundColor(.indigo)
                
                Text(currentChord.ChordTitle)
                    .font(.headline)
                
            }.frame(width: 150,height: 250)
        }
    }
    
    var body: some View {
        ZStack {
            CameraViewFinder
            
            //MARK: Removable Text and View
            Text(currentChord.ChordTitle)
            showChord.opacity(0.3)
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
