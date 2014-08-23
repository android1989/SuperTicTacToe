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
    
    // MARK: GKTurnBasedMatchmakerViewControllerDelegate
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFailWithError error: NSError!) {
        presentationViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFindMatch match: GKTurnBasedMatch!) {
        
        presentationViewController?.dismissViewControllerAnimated(true, completion: nil)
    
        var firstParticipant = match.participants.first as GKTurnBasedParticipant
        if firstParticipant.lastTurnDate == nil {
            delegate?.enterNewMatch(match)
        }else{
            if match.currentParticipant.playerID == GKLocalPlayer.localPlayer().playerID {
                delegate?.takeTurn(match)
            }else{
                delegate?.layoutMatch(match)
            }
        }
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, playerQuitForMatch match: GKTurnBasedMatch!) {
        presentationViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        match.endMatchInTurnWithMatchData(nil, completionHandler: nil)
    }
    
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController!) {
        presentationViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: GKLocalPlayerListener
    
    func player(player: GKPlayer!, matchEnded match: GKTurnBasedMatch!) {
        if match.matchID == currentMatch!.matchID {
            delegate?.recieveEndGame(match)
        } else {
            delegate?.sendNotice("Another Game Ended!", forMatch: match)
        }
    }
    
    func player(player: GKPlayer!, receivedTurnEventForMatch match: GKTurnBasedMatch!, didBecomeActive: Bool) {
        
        if match.matchID == currentMatch!.matchID {
            if (match.currentParticipant.playerID == GKLocalPlayer.localPlayer().playerID) {
                    // it's the current match and it's our turn now
                currentMatch = match
                delegate?.takeTurn(match)
            } else {
                // it's the current match, but it's someone else's turn
                currentMatch = match
                delegate?.layoutMatch(match)
            }
        } else {
            if (match.currentParticipant.playerID == GKLocalPlayer.localPlayer().playerID) {
                    // it's not the current match and it's our turn now
                    delegate?.sendNotice("Its your turn", forMatch: match)
            } else {
                // it's the not current match, and it's someone else's
                // turn
            }
        }
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
    // MARK: Helpers
    
    func nextParticipantForMatch(match: GKTurnBasedMatch) -> GKTurnBasedParticipant {
        
        var currentIndex = 0
        for participant in match.participants {
            if participant as GKTurnBasedParticipant == match.currentParticipant {
                break
            }
            ++currentIndex
        }

        var nextIndex = (currentIndex + 1) % countElements(match.participants)
        var nextParticipant = currentMatch?.participants[nextIndex] as GKTurnBasedParticipant
        
        return nextParticipant
    }
}
