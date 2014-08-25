//
//  RootViewController.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/23/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit
class RootViewController: UIViewController, ViewModelDelegate, UICollectionViewDelegate {
    
    //ViewModels
    var viewModel = MenuViewModel()
    
    //UI
    @IBOutlet var addGameButton: UIButton?
    @IBOutlet var matchesCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.registerCollectionViewCells(matchesCollectionView!)
        matchesCollectionView?.dataSource = viewModel
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        self.performSegueWithIdentifier("gameBoardSegue", sender: self)
    }
    
    // MARK: ViewModelDelegate
    
    func viewModelDataUpdated(viewModel: MenuViewModel) {
        viewModel.fetchObjectsIfNeeded()
        if viewModel.authenticated {
            addGameButton?.alpha = 1
            matchesCollectionView?.reloadData()
        }
        
    }
    
    // MARK: IBActions
    
    @IBAction func sendTurn() {
        if let currentMatch = GameCenterMatchManager.sharedInstance.currentMatch {
            var nextParticipant = GameCenterMatchManager.sharedInstance.nextParticipantForMatch(currentMatch)
            currentMatch.endTurnWithNextParticipants([nextParticipant], turnTimeout:DBL_MAX , matchData: nil, completionHandler: nil)
        }
    }

    @IBAction func addNewGame() {
        GameCenterMatchManager.sharedInstance.findMatch()
    }
}
