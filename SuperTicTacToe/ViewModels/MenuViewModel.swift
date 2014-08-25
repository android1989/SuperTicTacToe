//
//  MenuViewModel.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/24/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

protocol ViewModelDelegate : NSObjectProtocol {
    func viewModelDataUpdated(viewModel: MenuViewModel)
}

class MenuViewModel: NSObject, UICollectionViewDataSource {
   
    var authenticated = false
    var fetchedMatches = false
    var matches: Array<GKTurnBasedMatch>! {
        didSet {
            self.delegate?.viewModelDataUpdated(self)
        }
    }
    
    var delegate: ViewModelDelegate?
    
    override init() {
        matches = Array<GKTurnBasedMatch>()
        super.init()
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector:"authenticationChanged", name:GKPlayerAuthenticationDidChangeNotificationName , object: nil)
    }
    
    func fetchObjectsIfNeeded() {
        if !fetchedMatches && GKLocalPlayer.localPlayer().authenticated {
            GameCenterMatchManager.sharedInstance.allMatchesWithCompletionHandler { (matches, error) in
                if matches != nil {
                    self.matches = matches
                }
            }
            fetchedMatches = true
        }
    }
    
    // MARK: Authentication
    func authenticationChanged() {
        if GKLocalPlayer.localPlayer().authenticated {
            authenticated = true
            self.delegate?.viewModelDataUpdated(self)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func registerCollectionViewCells(collectionView: UICollectionView) {
        
        collectionView.registerNib(UINib(nibName: "MatchCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var matchCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MatchCollectionViewCell
        
        matchCell.configureWithMatch(self.matches[indexPath.item])
        return matchCell
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return self.matches.count
    }
}
