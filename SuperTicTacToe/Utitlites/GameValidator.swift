//
//  GameValidator.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/27/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//
import Foundation
import GameKit

class GameValidator: NSObject {

    func validateMove(gameModel: GameModel, gameMove: GameMove) -> Bool {

        if let previousGameMove = gameModel.moveSet.last? {
            //Check that smallSquare equals big square
            if previousGameMove.smallGridIndex != gameMove.bigGridIndex {
                return false
            }
        }
        
        
        //Check that square has not already been played in
        if gameModel[gameMove] != "" {
            return false
        }
        
        //Check if it is the players turn
        if gameModel.turnBasedMatch.currentParticipant.playerID != GKLocalPlayer.localPlayer().playerID {
            return false
        }
        
        return true
    }
}
