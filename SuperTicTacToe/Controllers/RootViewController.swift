//
//  RootViewController.swift
//  SuperTicTacToe
//
//  Created by Andrew Hulsizer on 8/23/14.
//  Copyright (c) 2014 Swift Yeti. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: IBActions
    
    @IBAction func sendTurn() {
        if let currentMatch = GameCenterMatchManager.sharedInstance.currentMatch {
            var nextParticipant = GameCenterMatchManager.sharedInstance.nextParticipantForMatch(currentMatch)
            currentMatch.endTurnWithNextParticipants([nextParticipant], turnTimeout:DBL_MAX , matchData: nil, completionHandler: nil)
        }
    }

    @IBAction func addNewGame() {
        GameCenterMatchManager.sharedInstance.findMatch()
    }
}
