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
    var pieceColor: UIColor!
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
            pieceColor = UIColor.clearColor();
        case GKLocalPlayer.localPlayer().playerID:
            pieceColor = UIColor(red: 123/255.0, green: 169/255.0, blue:237/255.0, alpha:1)
        default:
            pieceColor = UIColor(red: 237/255.0, green: 123/255.0, blue:169/255.0, alpha:1)
        }

        switch gameModel.bigGameBoardWinners[gameMove.bigGridIndex] {
        case "":
            backgroundColor = UIColor.whiteColor();
        case GKLocalPlayer.localPlayer().playerID:
            backgroundColor = UIColor(red: 123/255.0, green: 169/255.0, blue:237/255.0, alpha:0.5)
        default:
            backgroundColor = UIColor(red: 237/255.0, green: 123/255.0, blue:169/255.0, alpha:1)
        }
    }
}
