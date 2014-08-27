//
//  MatchMoveCollectionViewCell.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/25/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit
import GameKit

class MatchMoveCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1
    }

    func configureWithPlayerID(gameID: String) {
        switch gameID {
        case "":
            backgroundColor = UIColor.whiteColor();
        case GKLocalPlayer.localPlayer().playerID:
            backgroundColor = UIColor.blueColor();
        default:
            backgroundColor = UIColor.redColor();
        }
    }
}
