//
//  GameBoardViewController.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/21/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

let BoardCellIdentifier = "MatchMoveCollectionViewCell"

class GameBoardViewController: UIViewController, UICollectionViewDelegate, GameBoardViewModelDelegate {

    var selectedIndex: NSIndexPath
    @IBOutlet var gameBoardCollectionView: UICollectionView!
    
    var gameBoardViewModel: GameBoardViewModel! {
        didSet {
            self.gameBoardViewModel.delegate = self
        }
    }
    
    // MARK: Lifecycle
    
    required init(coder aDecoder: NSCoder) {
        selectedIndex = NSIndexPath(forItem: 0, inSection: 0)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.gameBoardCollectionView.reloadData()
    }

    // MARK: Setup
    
    func registerCells() {
        gameBoardCollectionView.registerNib(UINib(nibName: BoardCellIdentifier, bundle: nil), forCellWithReuseIdentifier:BoardCellIdentifier)
    }
    
    // MARK: Style
    func applyStyleFromViewModel() {
        gameBoardCollectionView.reloadData()
    }
    
    // MARK: IBActions
    
    @IBAction func dismissGameBoard() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        
        if gameBoardViewModel.currentTurn {
            var gameMove = GameMove(index:indexPath.item)
            gameBoardViewModel.gameModel[gameMove.bigGridIndex][gameMove.smallGridIndex] = GKLocalPlayer.localPlayer().playerID;
            GameCenterMatchManager.sharedInstance.submitTurn(gameBoardViewModel.gameModel);
        }
        
        
        gameBoardCollectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(BoardCellIdentifier, forIndexPath: indexPath) as MatchMoveCollectionViewCell
        
        var gameMove = GameMove(index:indexPath.item)
        
        cell.configureWithPlayerID(gameBoardViewModel.gameModel[gameMove.bigGridIndex][gameMove.smallGridIndex])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return gameBoardViewModel.gameModel.cellCount
    }
    
    // MARK: GameBoardViewModelDelegate
    
    func viewModelDataUpdated(viewModel: GameBoardViewModel) {
        applyStyleFromViewModel()
    }
}
