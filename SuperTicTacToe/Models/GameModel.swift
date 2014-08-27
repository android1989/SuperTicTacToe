//
//  GameModel.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/23/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

class GameMove: NSObject {
    
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
    var moveSet: [GameMove]!
    
    subscript(index: Int) -> Array<String> {
        get {
            // return an appropriate subscript value here
            assert(index < 9 && index >= 0, "Invalid index given")
            return bigGameBoard[index]
        }
        set(newValue) {
            // perform a suitable setting action here
            assert(index < 9 && index >= 0, "Invalid index given")
            bigGameBoard[index] = newValue
        }
    }

    init(turnBasedMatch: GKTurnBasedMatch) {
        let repeatValue = [String](count: 9, repeatedValue:"")
        bigGameBoard = [Array<String>](count: 9, repeatedValue:repeatValue)
        moveSet = [GameMove]()
        self.turnBasedMatch = turnBasedMatch
        cellCount = 9*9;
        super.init()
    }
    
    override init() {
        let repeatValue = [String](count: 9, repeatedValue:"")
        bigGameBoard = [Array<String>](count: 9, repeatedValue:repeatValue)
        moveSet = [GameMove]()
        turnBasedMatch = GKTurnBasedMatch()
        cellCount = 9*9;
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        cellCount = 9*9;
        bigGameBoard = aDecoder.decodeObjectForKey("gameBoard") as [[String]]
        moveSet = aDecoder.decodeObjectForKey("MoveSet") as [GameMove]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(bigGameBoard, forKey: "gameBoard")
        aCoder.encodeObject(moveSet, forKey: "MoveSet")
    }
}
