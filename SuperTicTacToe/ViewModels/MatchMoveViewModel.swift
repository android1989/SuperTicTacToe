//
//  MatchMoveViewModel.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/28/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

class MatchMoveViewModel: NSObject {
   
    var backgroundColor: UIColor!
    var highlightColor: UIColor!
    var lineThickness: CGFloat!
    var gameModel: GameModel!
    var gameMove: GameMove!
    init(gameModel: GameModel, gameMove: GameMove) {
        self.gameModel = gameModel
        self.gameMove = gameMove
        
        highlightColor = UIColor(white: 0.4, alpha: 0.6)
        lineThickness = 1
        
        if let lastGameMove = gameModel.moveSet.last? {
            if lastGameMove.smallGridIndex == gameMove.bigGridIndex {
                highlightColor = UIColor.blackColor()
                lineThickness = 3
            }
        }
        
        switch gameModel[gameMove] {
        case "":
            backgroundColor = UIColor.whiteColor();
        case GKLocalPlayer.localPlayer().playerID:
            backgroundColor = UIColor.blueColor();
        default:
            backgroundColor = UIColor.redColor();
        }
    }
}
