//
//  MatchBoardCollectionViewCell.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/25/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

class MatchBoardCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1
    }

    func configureWithGameBoard(gameBoard: [String]) {
        
        let buildFrame = bounds
        var index: Int = 0
        for index; index < gameBoard.count; ++index
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
            switch gameBoard[index] {
            case "":
                gameBoardCell.backgroundColor = UIColor.lightGrayColor();
            case GKLocalPlayer.localPlayer().playerID:
                gameBoardCell.backgroundColor = UIColor.blueColor();
            default:
                gameBoardCell.backgroundColor = UIColor.redColor();
            }
            
            addSubview(gameBoardCell)
        }
    }
}
