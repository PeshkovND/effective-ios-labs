//
//  Triangle.swift
//  ios-effective-labs
//
//  Created by test on 18.02.2023.
//

import UIKit

class Triangle: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.2))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        context.closePath()
        context.setFillColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        context.fillPath()
    }

}
