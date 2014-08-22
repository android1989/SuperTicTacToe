//
//  GameBoardGameCell.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/21/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit

class GameBoardGameCell: GameBoardCell, GameBoardDataSource {
    
    var gameBoard: GameBoardView!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        
        imageView = UIImageView(image: UIImage(named: "game_test"))
        
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    func gameBoardView(gameBoardView: GameBoardView!, cellForItemAtIndex index: Int!) -> GameBoardCell! {
        var view = GameBoardCell(frame: frame)
        
        
        return view
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        //resize layers
        imageView.frame = bounds
        //gameBoard.frame = bounds;
    }

}
