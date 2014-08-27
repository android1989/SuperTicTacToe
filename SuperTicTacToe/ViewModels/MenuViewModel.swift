//
//  MenuViewModel.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/24/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

protocol MenuViewModelDelegate : NSObjectProtocol {
    func viewModelDataUpdated(viewModel: MenuViewModel)
}


class MenuViewModel: NSObject {
   
    var authenticated = false
    var fetchedMatches = false
    var selectedMatch: GameModel?
    var delegate: MenuViewModelDelegate?
    
    var matches: Array<GameModel>! {
        didSet {
            self.delegate?.viewModelDataUpdated(self)
        }
    }
    
    override init() {
        matches = Array<GameModel>()
        super.init()
        registerNotifications()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    func registerNotifications() {
        
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector:"authenticationChanged", name:GKPlayerAuthenticationDidChangeNotificationName , object: nil)
        notificationCenter.addObserver(self, selector: "observeMatchesChange:", name: kGameCenterMatchesChanged, object:nil)
    }
    
    func observeMatchesChange(notification: NSNotification) {
        self.delegate?.viewModelDataUpdated(self)
    }
    
    // MARK: Authentication
    
    func authenticationChanged() {
        if GKLocalPlayer.localPlayer().authenticated {
            authenticated = true
            self.delegate?.viewModelDataUpdated(self)
        }
    }
}
