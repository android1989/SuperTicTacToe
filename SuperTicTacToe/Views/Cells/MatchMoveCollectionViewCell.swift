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

    @IBOutlet var pieceView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWithPlayerID(matchMoveViewModel: MatchMoveViewModel) {
        
        backgroundColor = matchMoveViewModel.backgroundColor
        pieceView.layer.cornerRadius = CGRectGetWidth(self.pieceView.bounds)/2
        bringSubviewToFront(pieceView)
        pieceView.backgroundColor = matchMoveViewModel.pieceColor
        
        layer.borderColor = matchMoveViewModel.highlightColor.CGColor
        layer.borderWidth = matchMoveViewModel.lineThickness
    }
}
