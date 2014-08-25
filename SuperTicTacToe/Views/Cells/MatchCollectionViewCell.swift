//
//  MatchCollectionViewCell.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/24/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

class MatchCollectionViewCell: UICollectionViewCell {

    @IBOutlet var opponetLabel: UILabel?
    @IBOutlet var statusLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWithMatch(match: GKTurnBasedMatch) {
//        var localPlayer = GKTurnBasedParticipant()
//        var opponent: GKTurnBasedParticipant?
//        //var participant = match.participants.first as GKTurnBasedParticipant
//        
//        for participant in match.participants {
//            if participant.playerID == GKLocalPlayer.localPlayer().playerID {
//                localPlayer = participant as GKTurnBasedParticipant
//            }else{
//                opponent = participant as GKTurnBasedParticipant
//            }
//        }
//        opponetLabel?.text = opponent?.player.displayName
//        
//        switch match.status {
//        case GKTurnBasedMatchStatus.Ended:
//            switch localPlayer.matchOutcome {
//            case GKTurnBasedMatchOutcome.Won:
//                statusLabel?.text = "Won"
//            case GKTurnBasedMatchOutcome.Lost:
//                statusLabel?.text = "Lost"
//            case GKTurnBasedMatchOutcome.Tied:
//                statusLabel?.text = "Tied"
//            default:
//                statusLabel?.text = "Unknown"
//            }
//        case GKTurnBasedMatchStatus.Open:
//            if match.currentParticipant == localPlayer {
//                statusLabel?.text = "Your Turn"
//            }else{
//                statusLabel?.text = "Their Turn"
//            }
//        default:
//            statusLabel?.text = "Unknown"
//        }
    }

}
