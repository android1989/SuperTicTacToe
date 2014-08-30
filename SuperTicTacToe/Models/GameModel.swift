//
//  GameModel.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/23/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

class GameMove: NSObject, NSCoding {
    
    init(index: Int) {
        var xSquare = (index%9)/3
        var ySquare = ((index/9)/3)*3
        var boardIndex = xSquare+ySquare
        var smallBoardIndex = ((index%9)%3)+((index/9)*3)%9
        self.bigGridIndex = boardIndex;
        self.smallGridIndex = smallBoardIndex;
        super.init()
    }
    
    init(bigGridIndex: Int, smallGridIndex: Int) {
        self.bigGridIndex = bigGridIndex
        self.smallGridIndex = smallGridIndex
        super.init()
    }
    
    var bigGridIndex: Int;
    var smallGridIndex: Int;
    
    required init(coder aDecoder: NSCoder) {
        bigGridIndex = aDecoder.decodeObjectForKey("bigGridIndex") as Int
        smallGridIndex = aDecoder.decodeObjectForKey("smallGridIndex") as Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(bigGridIndex, forKey: "bigGridIndex")
        aCoder.encodeObject(smallGridIndex, forKey: "smallGridIndex")
    }
}

/* Grid Layout

    0  1  2
    3  4  5
    6  7  8
*/

class GameModel: NSObject , NSCoding {
    
    var cellCount: Int;
    var turnBasedMatch = GKTurnBasedMatch()
    var bigGameBoard: [([String])]!
    var bigGameBoardWinners: [String]!
    var moveSet: [GameMove]!
    
    subscript(gameMove: GameMove) -> String {
        get {
            // return an appropriate subscript value here
            assert(gameMove.bigGridIndex < 9 && gameMove.bigGridIndex >= 0, "Invalid index given")
            assert(gameMove.smallGridIndex < 9 && gameMove.smallGridIndex >= 0, "Invalid index given")
            return bigGameBoard[gameMove.bigGridIndex][gameMove.smallGridIndex]
        }
        set(newValue) {
            // perform a suitable setting action here
            assert(gameMove.bigGridIndex < 9 && gameMove.bigGridIndex >= 0, "Invalid index given")
            assert(gameMove.smallGridIndex < 9 && gameMove.smallGridIndex >= 0, "Invalid index given")
            bigGameBoard[gameMove.bigGridIndex][gameMove.smallGridIndex] = newValue
        }
    }

    init(turnBasedMatch: GKTurnBasedMatch) {
        let repeatValue = [String](count: 9, repeatedValue:"")
        bigGameBoardWinners = [String](count: 9, repeatedValue:"")
        bigGameBoard = [Array<String>](count: 9, repeatedValue:repeatValue)
        moveSet = [GameMove]()
        self.turnBasedMatch = turnBasedMatch
        cellCount = 9*9;
        super.init()
    }
    
    override init() {
        let repeatValue = [String](count: 9, repeatedValue:"")
        bigGameBoardWinners = [String](count: 9, repeatedValue:"")
        bigGameBoard = [Array<String>](count: 9, repeatedValue:repeatValue)
        moveSet = [GameMove]()
        turnBasedMatch = GKTurnBasedMatch()
        cellCount = 9*9;
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        cellCount = 9*9;
        bigGameBoardWinners = aDecoder.decodeObjectForKey("gameBoardWinners") as [String]
        bigGameBoard = aDecoder.decodeObjectForKey("gameBoard") as [[String]]
        moveSet = aDecoder.decodeObjectForKey("MoveSet") as [GameMove]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(bigGameBoardWinners, forKey: "gameBoardWinners")
        aCoder.encodeObject(bigGameBoard, forKey: "gameBoard")
        aCoder.encodeObject(moveSet, forKey: "MoveSet")
    }
}
