//
//  SpinnerView.swift
//  CYOATemplate
//
//  Created by Jacobo de Juan Millon on 2023-06-04.
//

import SwiftUI
import Blackbird

struct SpinnerView: View {

    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    // The list of edges retrieved
    @BlackbirdLiveModels var spinners: Blackbird.LiveResults<Spinner>
    @BlackbirdLiveModels var edges: Blackbird.LiveResults<Edge>
    var size = 100.0
    @Binding var currentNodeId: Int

    @State var opacity = 0.0
    @State var outcome = 0
    @State var totalRotation = 0.0
    @State var currentRotation = 0.0
    var body: some View {

        if let spinner = spinners.results.first {
            VStack(spacing: size) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: size)
                        .frame(width: size*1.05, height: size*1.05)
                    Circle()
                        .trim(from: 0, to: Double(spinner.visualPercentage1) / 100)
                        .stroke(Color(color[spinner.color1]),
                                lineWidth: size)
                        .frame(width: size, height: size)
                    
                    Circle()
                        .trim(from: Double(spinner.visualPercentage1) / 100, to: Double(spinner.visualPercentage1 + spinner.visualPercentage2) / 100)
                        .stroke(Color(color[spinner.color2]),
                                lineWidth: size)
                        .frame(width: size, height: size)
                    Circle()
                        .trim(from: Double(spinner.visualPercentage1 + spinner.visualPercentage2) / 100, to: 1)
                        .stroke(Color(color[spinner.color3]),
                                lineWidth: size)
                        .frame(width: size, height: size)
                    Rectangle()
                        .frame(width: size, height: size/40)
                        .offset(x: size/2, y: 0)
                    Rectangle()
                        .frame(width: size, height: size/40)
                        .offset(x: size/2, y: 0)
                        .rotationEffect(Angle(degrees: 3.6 * Double(spinner.visualPercentage1)), anchor: .center)
                    Rectangle()
                        .frame(width: size, height: size/40)
                        .offset(x: size/2, y: 0)
                        .rotationEffect(Angle(degrees: 3.6 * Double(spinner.visualPercentage1 + spinner.visualPercentage2)), anchor: .center)
                    ArrowView(size: size * 0.75, width: 5)
                        .offset(x: 0, y: -size * 0.375)
                        .rotationEffect(Angle(degrees: 360 * currentRotation))
                }
                .onTapGesture {
                    Task {
                        withAnimation(.linear(duration: totalRotation * 0.85)) {
                            currentRotation = totalRotation
                        }
                        withAnimation(.linear(duration: 0.1).delay(totalRotation * 0.85)) {
                            opacity = 1.0
                        }
                    }
                }
                Button("Continue", action: {
                    currentNodeId = edges.results[outcome].to_node_id
                })
                .opacity(opacity)

            }
            .onAppear {
                currentRotation = 0
                opacity = 0
                let result = Int.random(in: 0...99)
                if result < spinner.actualPercentage1 {
                    outcome = 0
                    totalRotation = Double(Int.random(in: 3...5)) + Double(Int.random(in: 0..<spinner.visualPercentage1)) / 100 + 0.255
                }
                else if result < spinner.actualPercentage1 + spinner.actualPercentage2 {
                    outcome = 1
                    totalRotation = Double(Int.random(in: 3...5)) + Double(Int.random(in: spinner.visualPercentage1..<spinner.visualPercentage1 + spinner.visualPercentage2)) / 100 + 0.255
                }
                else {
                    outcome = 2
                    totalRotation = Double(Int.random(in: 3...5)) + Double(Int.random(in: spinner.visualPercentage1 + spinner.visualPercentage2...99)) / 100 + 0.255
                }
                
            }
        }
    }
    init(currentNodeId: Binding<Int>) {
        
        _spinners = BlackbirdLiveModels({ db in
            try await Spinner.read(from: db,
                                   sqlWhere: "id = ?", "\(currentNodeId.wrappedValue)")
        })
        _edges = BlackbirdLiveModels({ db in
            try await Edge.read(from: db,
                                sqlWhere: "from_node_id = ?", "\(currentNodeId.wrappedValue)")
        })
//         Set the current node
        _currentNodeId = currentNodeId
        
    }
}

struct SpinnerView_Previews: PreviewProvider {
    static var previews: some View {

        SpinnerView(currentNodeId: .constant(55))

    }
}
