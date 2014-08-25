//
//  GameModel.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/23/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit

enum GamePiece: Int {
    case NotTaken = 0
    case PlayerOne
    case PlayerTwo
}

/* Grid Layout

    0  1  2
    3  4  5
    6  7  8
*/

class GameModel: NSObject, NSCoding {
    
    var bigGameBoard: [([GamePiece])]!
    
    subscript(index: Int) -> Array<GamePiece> {
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
    
    override init() {
        super.init()
        
        let repeatValue = [GamePiece](count: 3, repeatedValue:GamePiece.NotTaken)
        bigGameBoard = [Array<GamePiece>](count: 9, repeatedValue:repeatValue)
    }
    
    required init(coder aDecoder: NSCoder) {
        
        var encodeArray = aDecoder.decodeObjectForKey("gameBoard") as [[Int]]
        
        var board = [[GamePiece]]()
        for array: [Int] in encodeArray {
            
            var smallBoard = [GamePiece]()
            for piece in array {
                smallBoard.append(GamePiece.fromRaw(piece)!)
            }
            
            board.append(smallBoard)
        }
    
        bigGameBoard = board
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        var encodeArray = [[Int]]()
        for array: [GamePiece] in bigGameBoard {
            
            var smallEncodeArray = [Int]()
            for piece: GamePiece in array {
                var gamePiece = piece as GamePiece
                smallEncodeArray.append(gamePiece.toRaw())
            }
            
            encodeArray.append(smallEncodeArray)
        }
        
        aCoder.encodeObject(encodeArray)
    }
}
