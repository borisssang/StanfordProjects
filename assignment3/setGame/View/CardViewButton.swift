//
//  CardView.swift
//  setGame
//
//  Created by Boris Angelov on 29.06.18.
//  Copyright © 2018 Boris Angelov. All rights reserved.
//

import UIKit

@IBDesignable
class CardViewButton: UIButton {
    
    var symbol: String?  {didSet{setNeedsDisplay()}}
    var color = UIColor() {didSet{setNeedsDisplay()}}
    var striping: String? {didSet{setNeedsDisplay()}}
    var numberOfSymbols = 0 {didSet{setNeedsDisplay()}}
    
    private func drawSquiggles(times numberOfTimes: Int)
    {
        let path = UIBezierPath()
        let allSquigglesWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
        let beginX = (frame.size.width - allSquigglesWidth) / 2
        
        for i in 0..<numberOfSymbols {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
            let currentShapeY = shapeVerticalMargin
            let curveXOffset = shapeWidth * 0.35
            
            path.move(to: CGPoint(x: currentShapeX, y: currentShapeY))
            
            path.addCurve(to: CGPoint(x: currentShapeX, y: currentShapeY + shapeHeight),
                          controlPoint1: CGPoint(x: currentShapeX + curveXOffset, y: currentShapeY + shapeHeight / 3),
                          controlPoint2: CGPoint(x: currentShapeX - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2))
            
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY + shapeHeight))
            
            path.addCurve(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY),
                          controlPoint1: CGPoint(x: currentShapeX + shapeWidth - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2),
                          controlPoint2: CGPoint(x: currentShapeX + shapeWidth + curveXOffset, y: currentShapeY + shapeHeight / 3))
            
            path.addLine(to: CGPoint(x: currentShapeX, y: currentShapeY))
        }
        
        self.path = path
    }
    
    private func drawDiamonds(times numberOfTimes: Int){
        let allDiamondsWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
        let beginX = (frame.size.width - allDiamondsWidth) / 2
        
        let path = UIBezierPath()
        
        for i in 0..<numberOfSymbols {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
            
            path.move(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
            path.addLine(to: CGPoint(x: currentShapeX, y: drawableCenter.y))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin + shapeHeight))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: drawableCenter.y))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
        }
        
        self.path = path
    }
    
    private func drawOvals(times numberOfTimes: Int){
        let allOvalsWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
        let beginX = (frame.size.width - allOvalsWidth) / 2
        path = UIBezierPath()
        
        for i in 0..<numberOfSymbols {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
            
            path!.append(UIBezierPath(roundedRect: CGRect(x: currentShapeX,
                                                          y: shapeVerticalMargin,
                                                          width: shapeWidth,
                                                          height: shapeHeight),
                                      cornerRadius: shapeWidth))
        }
    }
    
    var cardRect: CGRect {
        let drawableWidth = frame.size.width * 0.80
        let drawableHeight = frame.size.height * 0.90
        
        return CGRect(x: frame.size.width * 0.1,
                      y: frame.size.height * 0.05,
                      width: drawableWidth,
                      height: drawableHeight)
    }
    
    var path: UIBezierPath?
    
    override func draw(_ rect: CGRect) {
        
        switch symbol {
        case "diamond":
            drawDiamonds(times: numberOfSymbols)
        case "oval":
            drawOvals(times: numberOfSymbols)
        case "squiggle":
            drawSquiggles(times: numberOfSymbols)
        default: break
        }
        
        path!.lineCapStyle = .round
        
        switch striping {
        case "solid":
        color.setFill()
        path!.fill()
            
        case "unfilled":
        color.setStroke()
        path!.lineWidth = 1
        path!.stroke()
            
        case "striped":
            path!.lineWidth = 0.01 * frame.size.width
            color.setStroke()
            path!.stroke()
            path!.addClip()
        
        var currentX: CGFloat = 0
        
        let stripedPath = UIBezierPath()
        stripedPath.lineWidth = 0.005 * frame.size.width
        
        while currentX < frame.size.width {
            stripedPath.move(to: CGPoint(x: currentX, y: 0))
            stripedPath.addLine(to: CGPoint(x: currentX, y: frame.size.height))
            currentX += 0.03 * frame.size.width
        }
        
        color.setStroke()
        stripedPath.stroke()
        break
        default: break
    }
    }
    
    private var shapeHorizontalMargin: CGFloat {
        return cardRect.width * 0.05
    }
    
    private var shapeVerticalMargin: CGFloat {
        return cardRect.height * 0.05 + cardRect.origin.y
    }
    
    private var shapeWidth: CGFloat {
        return (cardRect.width - (2 * shapeHorizontalMargin)) / 3
    }
    
    private var shapeHeight: CGFloat {
        return cardRect.size.height * 0.9
    }
    
    private var drawableCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
}
