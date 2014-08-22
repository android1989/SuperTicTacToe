//
//  GameBoardViewController.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/21/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {

    var gameBoard: GameBoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameBoard = GameBoardView(frame: CGRectMake(0, 200, 320, 320))
        gameBoard.center = view.center
        view.addSubview(gameBoard)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animationBoardIn() {
        
    }

}
