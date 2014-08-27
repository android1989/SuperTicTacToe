//
//  MatchCollectionViewCell.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/24/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

protocol MatchCollectionViewCellDelegate {
    func cellRequestGameBoardDeletion(cell: MatchCollectionViewCell)
}

class MatchCollectionViewCell: UICollectionViewCell {

    var delegate: MatchCollectionViewCellDelegate?
    @IBOutlet var deleteButton: UIButton?
    @IBOutlet var opponetLabel: UILabel?
    @IBOutlet var statusLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWithModel(model: GameModel) {
        var localPlayer = GKTurnBasedParticipant()
        var opponent: GKTurnBasedParticipant?
        //var participant = match.participants.first as GKTurnBasedParticipant
        if let unwrappedParticipants = model.turnBasedMatch.participants? {
            for participant in unwrappedParticipants {
                
                if let playerID = participant.playerID? {
                    println(playerID)
                    if participant.playerID == GKLocalPlayer.localPlayer().playerID {
                        localPlayer = participant as GKTurnBasedParticipant
                    }else{
                        opponent = participant as GKTurnBasedParticipant
                    }
                }else{
                    opponent = participant as GKTurnBasedParticipant
                }
            }
        }
        
        if let player = opponent?.player? {
            opponetLabel?.text = opponent?.player?.displayName
        }
        
        switch model.turnBasedMatch.status {
        case GKTurnBasedMatchStatus.Ended:
            switch localPlayer.matchOutcome {
            case GKTurnBasedMatchOutcome.Won:
                statusLabel?.text = "Won"
            case GKTurnBasedMatchOutcome.Lost:
                statusLabel?.text = "Lost"
            case GKTurnBasedMatchOutcome.Tied:
                statusLabel?.text = "Tied"
            case GKTurnBasedMatchOutcome.Quit:
                statusLabel?.text = "Quit"
            default:
                statusLabel?.text = "Unknown"
            }
            deleteButton?.hidden = true
        case GKTurnBasedMatchStatus.Open:
            if model.turnBasedMatch.currentParticipant == localPlayer {
                statusLabel?.text = "Your Turn"
            }else{
                statusLabel?.text = "Their Turn"
            }
        case GKTurnBasedMatchStatus.Matching:
            if model.turnBasedMatch.currentParticipant == localPlayer {
                statusLabel?.text = "Your Turn"
            }else{
                statusLabel?.text = "Their Turn"
            }
            opponetLabel?.text = "Auto-matching..."
        default:
            statusLabel?.text = "Unknown"
        }
    }

    @IBAction func deleteGameBoard() {
        delegate?.cellRequestGameBoardDeletion(self)
    }
}
