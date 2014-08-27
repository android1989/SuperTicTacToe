//
//  GameBigBoardCollectionViewDelegate.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/25/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit

protocol GameBigBoardCollectionViewOwner {
    func gameBoardWasSelected(gameBoard: Array<String>)
}

class GameBigBoardCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
   
    var owner: GameBigBoardCollectionViewOwner?
    var gameBoards: Array<Array<String>>!
    
    func registerCellForCollectionView(collectionView: UICollectionView!) {
        
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return gameBoards.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        return nil
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        
        let gameBoard = gameBoards[indexPath.item]
        
        //Pass it back to owner
        self.owner?.gameBoardWasSelected(gameBoard)
    }
}
