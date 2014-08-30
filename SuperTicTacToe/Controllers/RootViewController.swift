//
//  RootViewController.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/23/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit
class RootViewController: UIViewController, MenuViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MatchCollectionViewCellDelegate {
    
    //ViewModels
    var viewModel = MenuViewModel()
    
    //UI
    @IBOutlet var addGameButton: UIButton?
    @IBOutlet var matchesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        registerCollectionViewCells(matchesCollectionView!)
        matchesCollectionView?.dataSource = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier  == kGameBoardSegue)
        {
            var gameBoardViewController = segue.destinationViewController as GameBoardViewController;
            
            gameBoardViewController.gameBoardViewModel = GameBoardViewModel(gameModel:viewModel.selectedMatch!)
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        
        viewModel.selectedMatch = viewModel.matches[indexPath.item]
        self.performSegueWithIdentifier(kGameBoardSegue, sender: self)
    }
    
    // MARK: ViewModelDelegate
    
    func viewModelDataUpdated(viewModel: MenuViewModel) {
        viewModel.fetchObjectsIfNeeded()
        if viewModel.authenticated {
            addGameButton?.alpha = 1
            matchesCollectionView?.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func registerCollectionViewCells(collectionView: UICollectionView) {
        
        let nib = UINib(nibName: "MatchCollectionViewCell", bundle: nil)
        collectionView.registerNib(nib,forCellWithReuseIdentifier: "MatchCollectionViewCell")
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        var matchCell = matchesCollectionView?.dequeueReusableCellWithReuseIdentifier("MatchCollectionViewCell", forIndexPath: indexPath) as MatchCollectionViewCell
        
        matchCell.delegate = self;
        matchCell.configureWithModel(viewModel.matches[indexPath.item])
        return matchCell
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return viewModel.matches.count
    }
    
    // MARK: MatchCollectionViewCellDelegate
    func cellRequestGameBoardDeletion(cell: MatchCollectionViewCell) {
        var index = matchesCollectionView?.indexPathForCell(cell)
        
        var gameModel = viewModel.matches[index!.item] as GameModel
        
        GameCenterMatchManager.sharedInstance.removeGameForPlayer(gameModel)
        viewModel.matches.removeAtIndex(index!.item)
        matchesCollectionView?.reloadData()
    }
    
    // MARK: IBAction

    @IBAction func addNewGame() {
        GameCenterMatchManager.sharedInstance.findMatch()
    }
}
