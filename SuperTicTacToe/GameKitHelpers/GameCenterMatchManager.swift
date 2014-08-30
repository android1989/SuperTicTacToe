//
//  GameCenterMatchManager.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/23/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

protocol GameCenterMatchManagerDelegate : NSObjectProtocol {
    func enterNewMatch(match: GKTurnBasedMatch)
    func layoutMatch(match: GKTurnBasedMatch)
    func takeTurn(match: GKTurnBasedMatch)
    func recieveEndGame(match: GKTurnBasedMatch)
    func sendNotice(notice: String, forMatch match: GKTurnBasedMatch)
}

class GameCenterMatchManager: NSObject, GKTurnBasedMatchmakerViewControllerDelegate, GKLocalPlayerListener {
    
    var userAuthenticaed = false
    var presentationViewController: UIViewController?
    var delegate: GameCenterMatchManagerDelegate?
    var currentMatch: GKTurnBasedMatch?
    var bannedList: Array<String>!
    
    class var sharedInstance : GameCenterMatchManager {
        struct Static {
            static let instance : GameCenterMatchManager = GameCenterMatchManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector:"authenticationChanged", name:GKPlayerAuthenticationDidChangeNotificationName , object: nil)
        
        var array = NSUserDefaults.standardUserDefaults().arrayForKey(kGameCenterBannedListKey) as [String]?
        if let unwrappedArray = array? {
            self.bannedList = unwrappedArray
        }else{
            self.bannedList = [String]()
        }
    }
    
    // MARK: Authentication
    func authenticateLocalUser() {
        if !GKLocalPlayer.localPlayer().authenticated {
            GKLocalPlayer.localPlayer().authenticateHandler = { (viewController, error) in
                
                if error != nil {
                    return
                } else if (viewController != nil) {
                    self.presentationViewController!.presentViewController(viewController, animated:true, completion:nil)
                }else{
                    GKLocalPlayer.localPlayer().registerListener(self)
                }
            };
        }
    }
    
    func authenticationChanged() {
        if GKLocalPlayer.localPlayer().authenticated && !userAuthenticaed {
            userAuthenticaed = true
        } else if !GKLocalPlayer.localPlayer().authenticated && userAuthenticaed {
            userAuthenticaed = false
        }
    }
    
    // MARK: Matchmaking
    
    func findMatch() {
        var request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        var requestViewController = GKTurnBasedMatchmakerViewController(matchRequest: request)
        requestViewController.turnBasedMatchmakerDelegate = self
        requestViewController.showExistingMatches = true
        
        presentationViewController?.presentViewController(requestViewController, animated:true, completion: nil)
    }
    
    func submitTurn(gameModel: GameModel, gameMove: GameMove) -> Bool {
        
        let gameValidator = GameValidator()
        if gameValidator.validateMove(gameModel, gameMove: gameMove) {
            
            gameModel[gameMove] = GKLocalPlayer.localPlayer().playerID
            gameModel.moveSet.append(gameMove)
            gameValidator.didWinBoard(gameModel)
            
            var participants = gameModel.turnBasedMatch.participants
            var data = NSKeyedArchiver.archivedDataWithRootObject(gameModel)
            
            let winnerID = gameValidator.didPlayerWin(gameModel)
            if winnerID != "" {
                
                let currentParticipant = gameModel.turnBasedMatch.currentParticipant
                let opponent = self.nextParticipantForMatch(gameModel.turnBasedMatch)
                
                if currentParticipant.playerID == winnerID {
                    currentParticipant.matchOutcome = GKTurnBasedMatchOutcome.Won
                    opponent.matchOutcome = GKTurnBasedMatchOutcome.Lost
                }else{
                    currentParticipant.matchOutcome = GKTurnBasedMatchOutcome.Lost
                    opponent.matchOutcome = GKTurnBasedMatchOutcome.Won
                }
                
                gameModel.turnBasedMatch.endMatchInTurnWithMatchData(data, completionHandler: { (error) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterModelChanged, object: nil, userInfo: [kGameCenterModelKey: gameModel.turnBasedMatch])
                    NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterMatchesChanged, object: nil)
                })
            }else{
                gameModel.turnBasedMatch.endTurnWithNextParticipants([self.nextParticipantForMatch(gameModel.turnBasedMatch)], turnTimeout: GKTurnTimeoutNone, matchData:data) { (error) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterModelChanged, object: nil, userInfo: [kGameCenterModelKey: gameModel.turnBasedMatch])
                    NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterMatchesChanged, object: nil)
                }
            }
            return true
        }else{
            return false
        }
    }
    
    // MARK: GKTurnBasedMatchmakerViewControllerDelegate
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFailWithError error: NSError!) {
        presentationViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFindMatch match: GKTurnBasedMatch!) {
        
        presentationViewController?.dismissViewControllerAnimated(true, completion: nil)
    
        NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterModelChanged, object: nil, userInfo: [kGameCenterModelKey: match])
        NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterMatchesChanged, object: nil)
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, playerQuitForMatch match: GKTurnBasedMatch!) {
        presentationViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterModelChanged, object: nil, userInfo: [kGameCenterModelKey: match])
        NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterMatchesChanged, object: nil)
        
        var participant = GameCenterMatchManager.sharedInstance.nextParticipantForMatch(match)
        match.participantQuitInTurnWithOutcome(GKTurnBasedMatchOutcome.Quit, nextParticipants: [participant], turnTimeout: GKTurnTimeoutNone, matchData: match.matchData, completionHandler: nil)
        
        participant.matchOutcome = GKTurnBasedMatchOutcome.Won

        match.endMatchInTurnWithMatchData(match.matchData) { (error) -> Void in
            
        }
    }
    
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController!) {
        presentationViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: GKLocalPlayerListener
    
    func player(player: GKPlayer!, matchEnded match: GKTurnBasedMatch!) {
    
        
        NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterModelChanged, object: nil, userInfo: [kGameCenterModelKey: match])
        NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterMatchesChanged, object: nil)
    }
    
    func player(player: GKPlayer!, receivedTurnEventForMatch match: GKTurnBasedMatch!, didBecomeActive: Bool) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterModelChanged, object: nil, userInfo: [kGameCenterModelKey: match])
        
        NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterMatchesChanged, object: nil)
    }
    
    func player(player: GKPlayer!, didRequestMatchWithOtherPlayers playersToInvite: [AnyObject]!) {
        
        presentationViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        var request = GKMatchRequest()
        request.playersToInvite = playersToInvite;
        request.maxPlayers = 2;
        request.minPlayers = 2;
        var viewController = GKTurnBasedMatchmakerViewController(matchRequest: request)
        
        viewController.showExistingMatches = false;
        viewController.turnBasedMatchmakerDelegate = self;
        
        presentationViewController?.presentViewController(viewController, animated: true, completion:nil)
    }
    
    // MARK: Matches
    func allMatchesWithCompletionHandler(completionHandler: (([GameModel]?, NSError!) -> Void)!) {
        GKTurnBasedMatch.loadMatchesWithCompletionHandler { (matches, error) -> Void in
            
            if completionHandler != nil {
                if matches != nil {
                    var gameModels = matches.filter({ (match) -> Bool in
                        for matchID in self.bannedList {
                            if matchID == match.matchID {
                                return false
                            }
                        }
                        
                        return true
                    })
                    
                    gameModels = gameModels.map({ (match) -> GameModel in
                        return GameModel(turnBasedMatch: match as GKTurnBasedMatch)
                    })
                    completionHandler(gameModels as? [GameModel], error)
                }else{
                    completionHandler([], error)
                }
            }
            
        }
    }
    
    func removeGameForPlayer(gameModel: GameModel) {
        var match = gameModel.turnBasedMatch;
        
        if match.status == GKTurnBasedMatchStatus.Ended {
            self.bannedList.append(match.matchID)
            return;
        }
        
        if let unwrappedParticipant = match.currentParticipant? {
            if unwrappedParticipant.playerID == GKLocalPlayer.localPlayer().playerID {
                var participants = GameCenterMatchManager.sharedInstance.nextParticipantForMatch(match)
                match.participantQuitInTurnWithOutcome(GKTurnBasedMatchOutcome.Quit, nextParticipants:[participants], turnTimeout: GKTurnTimeoutNone, matchData: match.matchData, completionHandler:{ (error) in
                    self.bannedList.append(match.matchID)
                    NSUserDefaults.standardUserDefaults().setObject(self.bannedList, forKey: kGameCenterBannedListKey)
                    NSUserDefaults.standardUserDefaults().synchronize()
                })
            }else{
                match.participantQuitOutOfTurnWithOutcome(GKTurnBasedMatchOutcome.Quit, withCompletionHandler: { (error) in
                    
                    self.bannedList.append(match.matchID)
                    NSUserDefaults.standardUserDefaults().setObject(self.bannedList, forKey: kGameCenterBannedListKey)
                    NSUserDefaults.standardUserDefaults().synchronize()
                })
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(kGameCenterMatchesChanged, object: nil)
    }
    // MARK: Helpers
    
    func nextParticipantForMatch(match: GKTurnBasedMatch) -> GKTurnBasedParticipant {
        
        var count = match.participants.count
        var currentIndex = 0
        for participant in match.participants {
            if participant as GKTurnBasedParticipant == match.currentParticipant {
                break
            }
            ++currentIndex
        }

        var nextIndex = (currentIndex + 1) % countElements(match.participants)
        var nextParticipant = match.participants[nextIndex] as GKTurnBasedParticipant
        
        return nextParticipant
    }
}
