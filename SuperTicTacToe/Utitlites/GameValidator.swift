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

        if gameModel.turnBasedMatch.status == GKTurnBasedMatchStatus.Ended {
            return false
        }
        
        if let previousGameMove = gameModel.moveSet.last? {
            //Check that smallSquare equals big square
            if previousGameMove.smallGridIndex != gameMove.bigGridIndex {
                
                //Check if bigGridIndex is full
                var smallSquareIndex = 0
                for smallSquareIndex; smallSquareIndex < 9; ++smallSquareIndex {
                    
                    var gameMove = GameMove(bigGridIndex: previousGameMove.smallGridIndex, smallGridIndex:smallSquareIndex)
                    //there is an empty space in the grid they should play
                    if gameModel[gameMove] == "" {
                        return false
                    }
                }
                
                //no empty space so they can play where ever they want
                return true
            }
        }
        
        
        //Check that square has not already been played in
        if gameModel[gameMove] != "" {
            return false
        }
        
        //Check if it is the players turn
        if let unwrappedParticipant = gameModel.turnBasedMatch.currentParticipant? {
            if  (unwrappedParticipant.matchOutcome == GKTurnBasedMatchOutcome.Lost ||
                unwrappedParticipant.matchOutcome == GKTurnBasedMatchOutcome.Won ||
                unwrappedParticipant.matchOutcome == GKTurnBasedMatchOutcome.Quit) {
                return false
            }
            if unwrappedParticipant.playerID != GKLocalPlayer.localPlayer().playerID {
                return false
            }
        }
        
        return true
    }
    
    func didWinBoard(gameModel: GameModel) {
        if let previousGameMove = gameModel.moveSet.last? {
            if gameModel.bigGameBoardWinners[previousGameMove.bigGridIndex] != "" {
                return
            }
            
            var board = Array<String>()
            var smallSquareIndex = 0
            for smallSquareIndex; smallSquareIndex < 9; ++smallSquareIndex {
                
                var gameMove = GameMove(bigGridIndex: previousGameMove.bigGridIndex, smallGridIndex:smallSquareIndex)
                board.append(gameModel[gameMove])
            }
            
            let playerID = GKLocalPlayer.localPlayer().playerID
            
            if self.checkBoardForWinner(board) == playerID {
                gameModel.bigGameBoardWinners[previousGameMove.bigGridIndex] = playerID
            }
        }
    }
    
    func didPlayerWin(gameModel: GameModel) -> String {
        
        return self.checkBoardForWinner(gameModel.bigGameBoardWinners)
    }
    
    func checkBoardForWinner(board: Array<String>) -> String {
        
        // Down Column 0
        //      0
        //      3
        //      6
        if checkIfAllPiecesMatch(board[0], gameMove1: board[3], gameMove2: board[6]) {
            return board[0]
        }
        
        // Diagonal Column 0
        //      0
        //        4
        //          8
        if checkIfAllPiecesMatch(board[0], gameMove1: board[4], gameMove2: board[8]) {
            return board[0]
        }
        
        // Horizonatl Column 0
        //      0 1 2
        //
        //
        if checkIfAllPiecesMatch(board[0], gameMove1: board[1], gameMove2: board[2]) {
            return board[0]
        }
        
        // Vertical Column 0
        //        1
        //        4
        //        7
        if checkIfAllPiecesMatch(board[1], gameMove1: board[4], gameMove2: board[7]) {
            return board[1]
        }
        
        // Diagonal Column 0
        //          2
        //        4
        //      6
        if checkIfAllPiecesMatch(board[2], gameMove1: board[4], gameMove2: board[6]) {
            return board[2]
        }
        
        // Horizonatl Column 0
        //          2
        //          5
        //          8
        if checkIfAllPiecesMatch(board[2], gameMove1: board[5], gameMove2: board[8]) {
            return board[8]
        }
        
        // Horizonatl Column 0
        //
        //      3 4 5
        //
        if checkIfAllPiecesMatch(board[3], gameMove1: board[4], gameMove2: board[5]) {
            return board[3]
        }
        
        // Horizonatl Column 0
        //
        //
        //      6 7 8
        if checkIfAllPiecesMatch(board[6], gameMove1: board[7], gameMove2: board[8]) {
            return board[6]
        }
        
        return ""
    }
    
    func checkIfAllPiecesMatch(gameMove0 :String, gameMove1 :String, gameMove2 :String) -> Bool {
        if gameMove0 == gameMove1 && gameMove0 == gameMove2 {
            if gameMove0 != "" {
                return true
            }else{
                return false
            }
        }
        return false
    }
}
