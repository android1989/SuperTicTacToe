//
//  GameBoardView.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/21/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit

protocol GameBoardDelegate : NSObjectProtocol {
    func gameBoardView(gameBoardView: GameBoardView!, didHighlightItemAtIndexPath indexPath: Int!);
    func gameBoardView(gameBoardView: GameBoardView!, didEndHighlightItemAtIndexPath indexPath: Int!);
    func gameBoardView(gameBoardView: GameBoardView!, didSelectItemAtIndexPath indexPath: Int!);
}

protocol GameBoardDataSource : NSObjectProtocol {
    func gameBoardView(gameBoardView: GameBoardView!, cellForItemAtIndex index: Int!) -> GameBoardCell!
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
    
    var cells = Array<GameBoardCell>()
    var highlightedCells = Array<GameBoardCell>()
    
    
    override init(frame: CGRect) {
    
        lineColor = UIColor.blackColor()
        super.init(frame: frame)
        
        buildLines()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cellForIndex(index :Int) -> GameBoardCell {
        return cells[index]
    }
    
    private func oneThird(value: CGFloat) -> CGFloat {
        return value/3
    }
    
    private func twoThird(value: CGFloat) -> CGFloat {
        return 2*value/3
    }
    
    func buildBoard() {
        cells.removeAll(keepCapacity: true)
        
        var index: Int = 0
        for index; index < 9; ++index
        {
            let gameBoardCell = dataSource?.gameBoardView(self, cellForItemAtIndex:index)
            let xCoord = CGFloat(index%3)*oneThird(CGRectGetWidth(bounds));
            let yCoord = CGFloat(index/3)*oneThird(CGRectGetHeight(bounds));
            
            var frame = gameBoardCell?.frame
            frame?.origin = CGPointMake(xCoord+lineWidth/2, yCoord+lineWidth/2)
            frame?.size = CGSizeMake(oneThird(CGRectGetWidth(bounds))-lineWidth, oneThird(CGRectGetHeight(bounds))-lineWidth)
            gameBoardCell?.frame = frame!
            
            cells.append(gameBoardCell!)
            addSubview(gameBoardCell!)
        }
    }
    
    private func buildLines() {
        
        lineX1 = buildLine(CGPointMake(oneThird(CGRectGetWidth(bounds)), lineWidth) , toPoint: CGPointMake(oneThird(CGRectGetWidth(bounds)), CGRectGetHeight(bounds)-lineWidth))
        lineX2 = buildLine(CGPointMake(twoThird(CGRectGetWidth(bounds)), lineWidth) , toPoint: CGPointMake(twoThird(CGRectGetWidth(bounds)), CGRectGetHeight(bounds)-lineWidth))
        lineY1 = buildLine(CGPointMake(lineWidth, oneThird(CGRectGetHeight(bounds))) , toPoint: CGPointMake(CGRectGetWidth(bounds)-lineWidth,  oneThird(CGRectGetHeight(bounds))))
        lineY2 = buildLine(CGPointMake(lineWidth, twoThird(CGRectGetHeight(bounds))) , toPoint: CGPointMake(CGRectGetWidth(bounds)-lineWidth,twoThird(CGRectGetHeight(bounds))))
        
        layer.addSublayer(lineX1)
        layer.addSublayer(lineX2)
        layer.addSublayer(lineY1)
        layer.addSublayer(lineY2)
    }
    
    private func buildLine(fromPoint: CGPoint, toPoint: CGPoint) -> CALayer {
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
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        //resize layers
        lineX1.frame = bounds
        lineX2.frame = bounds
        lineY1.frame = bounds
        lineY2.frame = bounds
    }
    
    // MARK: Touchs
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        
        for (var index = 0; index < touches.count; ++index) {
            
            let touch: UITouch = touches.allObjects[index] as UITouch
            
            let currentLocation = touch.locationInView(self)
            var cellIndex = 0
            for cell in cells {
                if (cell.frame .contains(currentLocation)) {
                    self.delegate?.gameBoardView(self, didEndHighlightItemAtIndexPath: cellIndex)
                }else{
                    if let highlightedIndex = find(highlightedCells, cell) {
                        self.delegate?.gameBoardView(self, didEndHighlightItemAtIndexPath: cellIndex)
                        highlightedCells.removeAtIndex(highlightedIndex)
                    }
                }
                ++cellIndex
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        for (var index = 0; index < touches.count; ++index) {
            
            let touch: UITouch = touches.allObjects[index] as UITouch
            
            let currentLocation = touch.locationInView(self)
            var cellIndex = 0
            for cell in cells {
                if (cell.frame .contains(currentLocation)) {
                    self.delegate?.gameBoardView(self, didEndHighlightItemAtIndexPath: cellIndex)
                }else{
                    if let highlightedIndex = find(highlightedCells, cell) {
                        self.delegate?.gameBoardView(self, didEndHighlightItemAtIndexPath: cellIndex)
                        highlightedCells.removeAtIndex(highlightedIndex)
                    }
                }
                ++cellIndex
            }
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        for (var index = 0; index < touches.count; ++index) {
            
            let touch: UITouch = touches.allObjects[index] as UITouch
            
            let currentLocation = touch.locationInView(self)
            var cellIndex = 0
            for cell in cells {
                if (cell.frame .contains(currentLocation)) {
                    self.delegate?.gameBoardView(self, didSelectItemAtIndexPath: cellIndex)
                }else{
                    if let highlightedIndex = find(highlightedCells, cell) {
                        self.delegate?.gameBoardView(self, didEndHighlightItemAtIndexPath: cellIndex)
                        highlightedCells.removeAtIndex(highlightedIndex)
                    }
                }
                ++cellIndex
            }
        }
    }
}
