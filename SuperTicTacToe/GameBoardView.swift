//
//  GameBoardView.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/21/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit

struct GameBoardIndexPath {
    let x = 0
    let y = 0
}

protocol GameBoardDelegate : NSObjectProtocol {
    func gameBoardView(gameBoardView: GameBoardView!, didHighlightItemAtIndexPath indexPath: GameBoardIndexPath!);
    func gameBoardView(gameBoardView: GameBoardView!, didEndHighlightItemAtIndexPath indexPath: GameBoardIndexPath!);
    func gameBoardView(gameBoardView: GameBoardView!, didSelectItemAtIndexPath indexPath: GameBoardIndexPath!);
}

protocol GameBoardDataSource : NSObjectProtocol {
    func gameBoardView(gameBoardView: GameBoardView!, cellForItemAtIndexPath indexPath: GameBoardIndexPath!) -> GameBoardCell!
}

class GameBoardView: UIView {
    weak var delegate: GameBoardDelegate?
    weak var dataSource: GameBoardDataSource?
    
    let lineWidth: CGFloat = 10
    
    var lineColor: UIColor!
    
    var lineX1: CALayer!
    var lineX2: CALayer!
    var lineY1: CALayer!
    var lineY2: CALayer!
    
    
    override init(frame: CGRect) {
    
        lineColor = UIColor.blackColor()
        super.init(frame: frame)
        
        buildLines()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func oneThird(value: CGFloat) -> CGFloat {
        return value/3
    }
    
    func twoThird(value: CGFloat) -> CGFloat {
        return 2*value/3
    }
    
    func buildLines() {
        
        lineX1 = buildLine(CGPointMake(oneThird(CGRectGetWidth(bounds)), lineWidth) , toPoint: CGPointMake(oneThird(CGRectGetWidth(bounds)), CGRectGetHeight(bounds)-lineWidth))
        lineX2 = buildLine(CGPointMake(twoThird(CGRectGetWidth(bounds)), lineWidth) , toPoint: CGPointMake(twoThird(CGRectGetWidth(bounds)), CGRectGetHeight(bounds)-lineWidth))
        lineY1 = buildLine(CGPointMake(lineWidth, oneThird(CGRectGetHeight(bounds))) , toPoint: CGPointMake(CGRectGetWidth(bounds)-lineWidth,  oneThird(CGRectGetHeight(bounds))))
        lineY2 = buildLine(CGPointMake(lineWidth, twoThird(CGRectGetHeight(bounds))) , toPoint: CGPointMake(CGRectGetWidth(bounds)-lineWidth,twoThird(CGRectGetHeight(bounds))))
        
        layer.addSublayer(lineX1)
        layer.addSublayer(lineX2)
        layer.addSublayer(lineY1)
        layer.addSublayer(lineY2)
    }
    
    func buildLine(fromPoint: CGPoint, toPoint: CGPoint) -> CALayer {
        var lineLayer = CALayer()
        var maskLayer = CAShapeLayer()
        
        maskLayer.bounds = bounds
        maskLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        
        var mutablePath = UIBezierPath()
        mutablePath.moveToPoint(fromPoint)
        mutablePath.addLineToPoint(toPoint)
        maskLayer.path = mutablePath.CGPath
        maskLayer.lineCap = kCALineCapRound
        maskLayer.lineWidth = lineWidth
        maskLayer.strokeColor = lineColor.CGColor
       
        return maskLayer
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        delegate?.gameBoardView(self, didHighlightItemAtIndexPath: nil)
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        delegate?.gameBoardView(self, didSelectItemAtIndexPath: nil)
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        delegate?.gameBoardView(self, didSelectItemAtIndexPath: nil)
    }
}
