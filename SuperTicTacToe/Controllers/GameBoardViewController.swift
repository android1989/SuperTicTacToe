//
//  GameBoardViewController.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/21/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController, GameBoardDataSource, GameBoardDelegate {

    var drilledInGameBoard: GameBoardView!
    var gameBoard: GameBoardView!
    var gameBoardZoomed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameBoard = GameBoardView(frame: CGRectMake(0, 200, 320, 320))
        gameBoard.center = view.center
        gameBoard.dataSource = self
        gameBoard.delegate = self
        gameBoard.buildBoard()
        view.addSubview(gameBoard)

        drilledInGameBoard = GameBoardView(frame: CGRectMake(0, 200, 300, 300))
        drilledInGameBoard.center = view.center
        drilledInGameBoard.hidden = true
        drilledInGameBoard.dataSource = self
        drilledInGameBoard.delegate = self
        drilledInGameBoard.userInteractionEnabled = false
        drilledInGameBoard.buildBoard()
        view.addSubview(drilledInGameBoard)
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animationBoardIn() {
        
    }

    // MARK: - GameBoardDataSource
    
    func gameBoardView(gameBoardView: GameBoardView!, cellForItemAtIndex index: Int!) -> GameBoardCell! {
        if gameBoardView === self.drilledInGameBoard {
            var view = GameBoardMoveCell(frame: CGRectMake(0, 0, Calculations.oneThird(CGRectGetWidth(self.drilledInGameBoard.bounds)), Calculations.oneThird(CGRectGetWidth(self.drilledInGameBoard.bounds))))
            return view
        }
        
        var view = GameBoardMinimalRepresentationView(frame: CGRectMake(0, 0, Calculations.oneThird(CGRectGetWidth(self.view.bounds)), Calculations.oneThird(CGRectGetWidth(self.view.bounds))))
        view.buildBoard()
        
        return view
    }
    
    // MARK: - GameBoardDelegate
    func gameBoardView(gameBoardView: GameBoardView!, didHighlightItemAtIndexPath indexPath: Int!) {
        
    }
    func gameBoardView(gameBoardView: GameBoardView!, didEndHighlightItemAtIndexPath indexPath: Int!) {
        
    }
    func gameBoardView(gameBoardView: GameBoardView!, didSelectItemAtIndexPath indexPath: Int!) {
        
        var cell = gameBoardView.cellForIndex(indexPath)
        
        if gameBoardZoomed {
            drilledInGameBoard.hidden = true
            cell.hidden = false
            UIView.animateWithDuration(1, animations: {  [unowned self] () -> Void in
                self.gameBoard.transform = CGAffineTransformIdentity
            }, completion: {  [unowned self] (finished) -> Void in
                self.gameBoardZoomed = false;
            })
            return
        }
        
        var xAnchor = CGFloat(indexPath%3)/2.0
        var yAnchor = CGFloat(indexPath/3)/2.0
        
        var scale = (CGRectGetWidth(self.gameBoard.frame)/CGRectGetWidth(cell.frame))*0.9
        var frame = self.gameBoard.frame;
        self.gameBoard.layer.anchorPoint = CGPointMake(xAnchor, yAnchor)
        self.gameBoard.frame = frame
        UIView.animateWithDuration(1, animations: { [unowned self] () -> Void in
            self.gameBoard.transform = CGAffineTransformMakeScale(scale, scale)
        }, completion: {  [unowned self] (finished) -> Void in
            self.drilledInGameBoard.hidden = false
            cell.hidden = true
        })
        
        gameBoardZoomed = true
    }
    
    // MARK: - Pinch Gesture
    
    @IBAction func pinchGestureRecognized(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        if gameBoardZoomed {
            
            switch pinchGestureRecognizer.state {
            case UIGestureRecognizerState.Began, UIGestureRecognizerState.Changed:
                let scale = min(2, max(pinchGestureRecognizer.scale, 1))
                var transform = CGAffineTransformScale(self.gameBoard.transform, scale, scale);
                pinchGestureRecognizer.scale = 1.0;
            case UIGestureRecognizerState.Ended:
                drilledInGameBoard.hidden = true
                UIView.animateWithDuration(1, animations: { [unowned self] () -> Void in
                    self.gameBoard.transform = CGAffineTransformIdentity
                })
                gameBoardZoomed = false
            default:
                print(self)
            }
        }
    }
}
