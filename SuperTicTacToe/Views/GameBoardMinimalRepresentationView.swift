//
//  GameBoardMinimalRepresentationView.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/23/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit

class GameBoardMinimalRepresentationView: GameBoardCell {

    var cells = Array<UIView>()
    
    func buildBoard() {
        cells.removeAll(keepCapacity: true)
        
        let buildFrame = bounds
        var index: Int = 0
        for index; index < 9; ++index
        {
            let gameBoardCell = UIView()
            let width = Calculations.oneThird(CGRectGetWidth(buildFrame))*0.5
            let height = Calculations.oneThird(CGRectGetHeight(buildFrame))*0.5
            let xCoord = (CGFloat(index%3)*Calculations.oneThird(CGRectGetWidth(buildFrame)))+Calculations.oneThird(CGRectGetWidth(buildFrame))/2-width/4
            let yCoord = (CGFloat(index/3)*Calculations.oneThird(CGRectGetHeight(buildFrame)))+Calculations.oneThird(CGRectGetHeight(buildFrame))/2-height/4
            
            var frame = gameBoardCell.frame
            frame.size = CGSizeMake(width, height)
            gameBoardCell.frame = frame
            gameBoardCell.center = CGPointMake(xCoord, yCoord)
            gameBoardCell.layer.cornerRadius = width/2
            gameBoardCell.backgroundColor = UIColor.darkGrayColor()
            cells.append(gameBoardCell)
            addSubview(gameBoardCell)
        }
    }
    
    private func buildLines() {
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let buildFrame = bounds
        var index: Int = 0
        for index; index < 9; ++index
        {
            let gameBoardCell = cells[index]
            let width = Calculations.oneThird(CGRectGetWidth(buildFrame))*0.5
            let height = Calculations.oneThird(CGRectGetHeight(buildFrame))*0.5
            let xCoord = (CGFloat(index%3)*Calculations.oneThird(CGRectGetWidth(buildFrame)))+Calculations.oneThird(CGRectGetWidth(buildFrame))/2
            let yCoord = (CGFloat(index/3)*Calculations.oneThird(CGRectGetHeight(buildFrame)))+Calculations.oneThird(CGRectGetHeight(buildFrame))/2
            
            gameBoardCell.center = CGPointMake(xCoord, yCoord)
        }
    }
}
