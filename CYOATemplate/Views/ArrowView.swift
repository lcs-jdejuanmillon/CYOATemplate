//
//  ArrowView.swift
//  CYOATemplate
//
//  Created by Jacobo de Juan Millon on 2023-06-04.
//

import SwiftUI

struct ArrowView: View {
    var size: Double
    var width: Double
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: width, height: size)
                .cornerRadius(width / 2)
            Rectangle()
                .frame(width: width, height: size / 3)
                .cornerRadius(width / 2)
                .rotationEffect(Angle(degrees: 30))
                .offset(x: -size / 12, y: -size / 2 + size / 12 * sqrt(3))
            Rectangle()
                .frame(width: width, height: size / 3)
                .cornerRadius(width / 2)
                .rotationEffect(Angle(degrees: 330))
                .offset(x: size / 12, y: -size / 2 + size / 12 * sqrt(3))
        }
    }
}

struct ArrowView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowView(size: 300, width: 5)
    }
}
