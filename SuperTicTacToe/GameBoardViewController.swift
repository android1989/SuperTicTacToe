//
//  GameBoardViewController.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/21/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController, GameBoardDataSource, GameBoardDelegate {

    var gameBoard: GameBoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameBoard = GameBoardView(frame: CGRectMake(0, 200, 320, 320))
        gameBoard.center = view.center
        gameBoard.dataSource = self
        gameBoard.delegate = self
        gameBoard.buildBoard()
        view.addSubview(gameBoard)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animationBoardIn() {
        
    }

    // MARK: - GameBoardDataSource
    
    func gameBoardView(gameBoardView: GameBoardView!, cellForItemAtIndex index: Int!) -> GameBoardCell! {
        var view = GameBoardCell(frame: CGRectMake(0, 0, 320, 320))
        view.backgroundColor = UIColor.blueColor()
        
        return view
    }
    
    // MARK: - GameBoardDelegate
    func gameBoardView(gameBoardView: GameBoardView!, didHighlightItemAtIndexPath indexPath: Int!) {
        
    }
    func gameBoardView(gameBoardView: GameBoardView!, didEndHighlightItemAtIndexPath indexPath: Int!) {
        
    }
    func gameBoardView(gameBoardView: GameBoardView!, didSelectItemAtIndexPath indexPath: Int!) {
        UIView.animateWithDuration(1, animations: { [unowned self] () -> Void in
            self.gameBoard.transform = CGAffineTransformMakeScale(2, 2)
        })
    }
}
