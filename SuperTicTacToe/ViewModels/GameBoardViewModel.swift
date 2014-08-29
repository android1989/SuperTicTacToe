//
//  GameBoardViewModel.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/26/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

protocol GameBoardViewModelDelegate : NSObjectProtocol {
    func viewModelDataUpdated(viewModel: GameBoardViewModel)
}

class GameBoardViewModel: NSObject {
   
    
    var gameModel: GameModel
    var delegate: GameBoardViewModelDelegate?
    var turnText: String {
        get {
            if let unwrappedParticipant = self.gameModel.turnBasedMatch.currentParticipant? {
                if unwrappedParticipant.playerID == GKLocalPlayer.localPlayer().playerID {
                    return "Your Turn"
                }else{
                    return "Their Turn"
                }
            }
            return "Their Turn"
        }
    }
    var currentTurn: Bool {
        get {
            return self.gameModel.turnBasedMatch.currentParticipant.playerID == GKLocalPlayer.localPlayer().playerID;
        }
    }
    
    // MARK: Lifecycle
    init(gameModel: GameModel) {
        self.gameModel = gameModel
        
        super.init()
        
        //setup
        registerNotifications()
        loadMatch()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func loadMatch() {
        gameModel.turnBasedMatch.loadMatchDataWithCompletionHandler { [unowned self] (data, error) -> Void in
            if data != nil && data.length != 0 {
                var model = NSKeyedUnarchiver.unarchiveObjectWithData(data) as GameModel
                self.gameModel.bigGameBoard = model.bigGameBoard;
                self.gameModel.moveSet = model.moveSet
                self.delegate?.viewModelDataUpdated(self)
            }
        }
    }
    // MARK: Notifications
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "observeModelChange:", name: kGameCenterModelChanged, object:nil)
    }
    
    func observeModelChange(notification: NSNotification) {
        if let unwrappedUserInfo: Dictionary = notification.userInfo? {
            let updatedModel = unwrappedUserInfo[kGameCenterModelKey] as GKTurnBasedMatch
            if updatedModel.matchID == gameModel.turnBasedMatch.matchID {
                self.gameModel.turnBasedMatch = updatedModel
                if let matchData = updatedModel.matchData? {
                    var model = NSKeyedUnarchiver.unarchiveObjectWithData(matchData) as GameModel
                    self.gameModel.bigGameBoard = model.bigGameBoard;
                    self.gameModel.moveSet = model.moveSet
                }
                
                didGameEnd()
                checkIfUsersTurn()
                self.delegate?.viewModelDataUpdated(self)
            }
        }
    }
    
    func didGameEnd() {
    
    }
    func checkIfUsersTurn() {
        if let unwrappedParticipant = gameModel.turnBasedMatch.currentParticipant? {
            if let unwrappedPlayerID = unwrappedParticipant.playerID? {
                if (unwrappedPlayerID == GKLocalPlayer.localPlayer().playerID) {
                    //YOUR TURN
                } else {
                    //SOMEONE ELSES TURN
                }
            }
        }
        
    }
    
    
    
}
